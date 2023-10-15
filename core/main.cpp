/**
 * @Author: Xia Yunkai
 * @Date:   2022-04-22 13:23:09
 * @Last Modified by:   Xia Yunkai
 * @Last Modified time: 2023-10-15 22:22:34
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "common/Tools.h"
#include "roadmap_manager/RoadmapJsonTreeModel.h"
#include "cad_reader/cadreader.h"
// #include "laser_odom_calibration/laser_odom_calibration.h"
// #include "task_manager/taskmanager.h"
int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QGuiApplication::setOrganizationName("Sunny Optical");
    qmlRegisterSingletonType<common::Tools>("Tools", 1, 0, "Tools", common::tools_singletontype_provider);
    qmlRegisterType<roadmap_manager::RoadmapJsonTreeModel>("Roadmap", 1, 0, "Roadmap");
    qmlRegisterType<CADReader>("CADReader", 1, 0, "CADReader");
    // qmlRegisterType<LaserOdomCalibration>("LaserOdomCalibration", 1, 0, "LaserOdomCalibration");
    // qmlRegisterType<TaskManager>("TaskManager", 1, 0, "TaskManager");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
