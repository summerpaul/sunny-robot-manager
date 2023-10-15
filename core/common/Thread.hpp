#ifndef __TS_THREAD_H__
#define __TS_THREAD_H__

#include <functional>
#include <thread>
#include <condition_variable>
#include <mutex>
#include <limits>
#include <cassert>
#include <string>

#ifndef H_CASE_STRING_BIGIN
#define H_CASE_STRING_BIGIN(state) \
    switch (state)                 \
    {
#define H_CASE_STRING(state) \
    case state:              \
        return #state;       \
        break;
#define H_CASE_STRING_END() \
    default:                \
        return "Unknown";   \
        break;              \
        }
#endif

/*
特性
1、基于C++11实现，实现跨平台可用
2、支持挂起、恢复功能
3、支持多次关闭、重启功能
4、支持延时功能
5、支持在线程函数中使用IsExiting()监听退出事件
6、支持在挂起时退出线程
7、可不调用Stop()退出，在线程析构函数中自动退出线程
*/

namespace common
{

    class Thread
    {
    public:
        typedef std::function<void(void *arg)> ThreadFuncCallback;

        enum Status
        {
            kRunning = 1,
            kSuspend = 2,
            kStopping = 3,
            kStopped = 4,
        };

    public:
        Thread() : m_status(kStopped)
        {
        }

        Thread(const ThreadFuncCallback &cb) : m_threadCallback(cb),
                                               m_status(kStopped)
        {
        }

        ~Thread()
        {
            if (kStopped != m_status)
            {
                stop();
            }
        }

        bool assignTask(const ThreadFuncCallback &cb)
        {
            std::lock_guard<std::mutex> lock(m_mtx);

            assert(kStopped == m_status);

            m_threadCallback = cb;

            return true;
        }

        bool start()
        {
            std::lock_guard<std::mutex> lock(m_mtx);

            assert(kStopped == m_status);

            m_thread = std::thread(m_threadCallback, this);

            m_status = kRunning;

            return true;
        }

        void stop(/*unsigned long long timeouts = std::numeric_limits<int>::max()*/)
        {
            {
                std::unique_lock<std::mutex> lock(m_mtx);

                assert(kRunning == m_status || kSuspend == m_status);

                if (kSuspend == m_status)
                {
                    m_cond.notify_all();
                }

                m_status = kStopping;

                lock.unlock();
            }

            if (m_thread.joinable())
            {
                m_thread.join();

                if ((kStopping == m_status))
                {
                    m_status = kStopped;
                }
            }
        }

        bool suspend()
        {
            std::lock_guard<std::mutex> lock(m_mtx);

            assert(kRunning == m_status);

            m_status = kSuspend;

            return true;
        }

        bool resume()
        {
            std::unique_lock<std::mutex> lock(m_mtx);

            assert(kSuspend == m_status);

            m_status = kRunning;
            m_cond.notify_all();

            return true;
        }

        //TODO 2018.0511 考虑是否实现等待外部信号
        //bool IsExiting(unsigned long long timeouts = 0, std::condition_variable* external_cv = nullptr);
        bool isExiting(unsigned long long timeouts = 0)
        {
            std::unique_lock<std::mutex> lock(m_mtx);

            bool isExiting = false;

            switch (m_status)
            {
            case kRunning:
                lock.unlock();

                if (timeouts > 0)
                {
                    std::this_thread::sleep_for(std::chrono::milliseconds(timeouts));
                    if (kStopping == m_status)
                    {
                        m_status = kStopped;

                        isExiting = true;
                    }
                }
                break;
            case kSuspend:
            {
                m_cond.wait(lock, [&]() -> bool
                            { return (kRunning == m_status) || (kStopping == m_status); });
                if (kStopping == m_status)
                {
                    m_status = kStopped;

                    isExiting = true;
                }
            }
            break;
            case kStopping:
            {
                m_status = kStopped;

                isExiting = true;
            }
            break;
            case kStopped:
            {
                isExiting = true;
            }
            break;
            default:
                isExiting = true;
                break;
            }

            return isExiting;
        }

        void sleep(unsigned long long timeouts = 0)
        {
            //std::chrono::steady_clock::time_point start;
            //std::chrono::steady_clock::time_point end;
            //start = std::chrono::steady_clock::now();
            //end = std::chrono::steady_clock::now();
            //auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
            //TRACE("time=%lf\n", double(duration.count()) * std::chrono::microseconds::period::num / std::chrono::microseconds::period::den);

            if (timeouts > 0)
            {
                std::this_thread::sleep_for(std::chrono::milliseconds(timeouts));
            }
        }

        void setCallbackName(std::string name)
        {
            m_cbName = name;
        }

    private:
        const char *StatusToString() const
        {
            H_CASE_STRING_BIGIN(m_status);
            H_CASE_STRING(kRunning);
            H_CASE_STRING(kSuspend);
            H_CASE_STRING(kStopping);
            H_CASE_STRING(kStopped);
            H_CASE_STRING_END();
        }

    private:
        ThreadFuncCallback m_threadCallback;

        std::thread m_thread;

        std::condition_variable m_cond;

        std::mutex m_mtx;

        Status m_status;

        std::string m_cbName;
    };

} //namespace common

#endif // !__TS_THREAD_H__