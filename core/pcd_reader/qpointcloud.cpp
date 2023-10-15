#include "qpointcloud.h"
#include <pcl/PCLPointCloud2.h>
#include <pcl/point_types.h>
#include <pcl/common/centroid.h>
#include <pcl/common/common.h>
#include <QRgb>
#include <QFile>
#include <QVector>
#include <limits>
#include <QDebug> //DBG

class QPointcloudPrivate
{
public:
    QPointcloudPrivate(QPointcloud* p)
        : m_parent(p)
        , m_pointcloud(nullptr)
        , m_width(0)
        , m_height(1)
        , m_is_bigendian(0)
        , m_point_step(0)
        , m_row_step(0)
        , m_data()
        , m_is_dense(0)
        , m_minimum()
        , m_maximum()
        , m_centroid()
        , m_offset()
        , m_dirtyMinMax(true)
        , m_dirtyCentroid(true)
    {}
    QPointcloud *m_parent;
    pcl::PCLPointCloud2 *m_pointcloud;
    QList<QPointfield*> m_fields;

    quint32 m_height;
    quint32 m_width;

    quint8 m_is_bigendian;
    quint32 m_point_step;
    quint32 m_row_step;
    QByteArray m_data;
    quint8 m_is_dense;

    QVector3D m_minimum;
    QVector3D m_maximum;
    QVector3D m_centroid;
    QVector3D m_offset;
    bool m_dirtyMinMax;
    bool m_dirtyCentroid;

    static void fields_append(QQmlListProperty<QPointfield> *self, QPointfield* f);
    static int fields_count(QQmlListProperty<QPointfield> *self);
    static QPointfield* fields_at(QQmlListProperty<QPointfield> *self, int i);
    static void fields_clear(QQmlListProperty<QPointfield> *self);

    void updateMinMax()
    {

        pcl::PointXYZ min;
        pcl::PointXYZ max;
        pcl::PointCloud<pcl::PointXYZ> pc;
        pcl::fromPCLPointCloud2( *m_pointcloud, pc);
        pcl::getMinMax3D(pc, min, max);
        m_minimum = QVector3D(min.x, min.y, min.z);
        m_maximum = QVector3D(max.x, max.y, max.z);
        m_dirtyMinMax = false;
    }
    void updateCentroid()
    {

    }

//    void updateFields()
//    {
//        for(QList<QPointfield*>::iterator qiter(m_fields.begin()) ; qiter != m_fields.end() ; qiter++)
//        {
//            (*qiter)->deleteLater();
//        }
//        m_fields.clear();
//#if WITH_PCL
//        if(m_pointcloud)
//        {
//            for(std::vector< ::pcl::PCLPointField>::iterator iter(m_pointcloud->fields.begin());
//                iter != m_pointcloud->fields.end(); iter++)
//            {
//                m_fields.append( new QPointfield(m_parent, &(*iter) ) );
//            }
//        }
//    #if WITH_LAS
//        else
//    #endif
//#endif
//#if WITH_LAS
//        {
//            // Standard LAS fields
//            QPointfield *f;
//            f = new QPointfield(m_parent, "x", 0, QPointfield::FLOAT32, 1);
//            f = new QPointfield(m_parent, "y", 8, QPointfield::FLOAT32, 1);
//            f = new QPointfield(m_parent, "z", 16, QPointfield::FLOAT32, 1);
//            f = new QPointfield(m_parent, "intensity", 24, QPointfield::FLOAT32, 1);
//        }
//#endif
//        //else TODO: completely custom format for pointclouds
//    }
};

QPointcloud::QPointcloud(QPointcloud *copy)
    :m_priv(new QPointcloudPrivate(this))
{

    this->setPointcloud( *copy->m_priv->m_pointcloud );

}

QPointcloud::QPointcloud(QObject *parent)
    :QObject(parent),
     m_priv(new QPointcloudPrivate(this))
{

    //m_priv->m_pointcloud = new pcl::PCLPointCloud2();

}


QPointcloud::QPointcloud(pcl::PCLPointCloud2 *pointcloud)
    :m_priv(new QPointcloudPrivate(this))
{
    m_priv->m_pointcloud = pointcloud;
}


QPointcloud::~QPointcloud()
{

    if(m_priv->m_pointcloud != nullptr)
    {
        delete m_priv->m_pointcloud;
    }

    delete m_priv;
}

void QPointcloud::updateAttributes()
{

    if(m_priv->m_pointcloud)
    {
        m_priv->m_fields.clear();
        for(int i=0 ; m_priv->m_pointcloud->fields.size() >i ; ++i)
        {
            pcl::PCLPointField &pf( m_priv->m_pointcloud->fields[i] );
            m_priv->m_fields.append(new QPointfield(&pf));
        }
    }
    else
    {
        // LAS Attributes are read when LAS is read
    }
}

quint32 QPointcloud::height() const
{

    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->height;
    }
    else
    {
        return m_priv->m_height;
    }
}

quint32 QPointcloud::width() const
{
    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->width;
    }
    else
    {
        return m_priv->m_width;
    }
}

QQmlListProperty<QPointfield> QPointcloud::fields()
{
    return QQmlListProperty<QPointfield>(this, static_cast<void*>(m_priv), &QPointcloudPrivate::fields_append, &QPointcloudPrivate::fields_count, &QPointcloudPrivate::fields_at, &QPointcloudPrivate::fields_clear);
}

void QPointcloudPrivate::fields_append(QQmlListProperty<QPointfield> *self, QPointfield *f)
{
    QPointcloudPrivate *that = static_cast<QPointcloudPrivate*>(self->data);
    if(that->m_pointcloud)
    {
        // This is not typical for PCL. PCL would create a new pointcloud instead.
        // if this is needed, there should be a conversion from PCL Pointcloud to a
        // custom pointcloud format.
        Q_ASSERT_X(false, "QPointcloud::fields_append", "Must not be called.");
        pcl::PCLPointCloud2 *p = static_cast<pcl::PCLPointCloud2*>(that->m_pointcloud);
        p->fields.push_back(*f->getPointfield());
    }
    else
    {
        that->m_fields.append(f);
    }
}

int QPointcloudPrivate::fields_count(QQmlListProperty<QPointfield> *self)
{
    QPointcloudPrivate *that = static_cast<QPointcloudPrivate*>(self->data);
    if(that->m_pointcloud)
    {
        Q_ASSERT_X(that->m_fields.count() == 0, "QPointcloudPrivate::fields_count", "Mixed up pcl and non pcl.");
        pcl::PCLPointCloud2 *p = static_cast<pcl::PCLPointCloud2*>(that->m_pointcloud);
        return p->fields.size();
    }
    else
    {
        that->m_fields.count();
    }
}

QPointfield *QPointcloudPrivate::fields_at(QQmlListProperty<QPointfield> *self, int i)
{
    QPointcloudPrivate *that = static_cast<QPointcloudPrivate*>(self->data);
    if(that->m_pointcloud)
    {
        Q_ASSERT_X(that->m_fields.count() == 0, "QPointcloudPrivate::fields_count", "Mixed up pcl and non pcl.");
        pcl::PCLPointCloud2 *p = static_cast<pcl::PCLPointCloud2*>(that->m_pointcloud);
        return new QPointfield(&p->fields.at(i));
    }
    else
    {
        that->m_fields.at(i);
    }
}

void QPointcloudPrivate::fields_clear(QQmlListProperty<QPointfield> *self)
{
    QPointcloudPrivate *that = static_cast<QPointcloudPrivate*>(self->data);
    if(that->m_pointcloud)
    {
        Q_ASSERT_X(that->m_fields.count() == 0, "QPointcloudPrivate::fields_count", "Mixed up pcl and non pcl.");
        pcl::PCLPointCloud2 *p = static_cast<pcl::PCLPointCloud2*>(that->m_pointcloud);
        p->fields.clear();
    }
    else
    {
        that->m_fields.clear();
    }
}

quint8 QPointcloud::is_bigendian() const
{
    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->is_bigendian;
    }
    else
    {
        return m_priv->m_is_bigendian;
    }
}

quint32 QPointcloud::point_step() const
{
    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->point_step;
    }
    else
    {
        return m_priv->m_point_step;
    }
}

quint32 QPointcloud::row_step() const
{
    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->row_step;
    }
    else
    {
        return m_priv->m_row_step;
    }
}

QByteArray QPointcloud::data() const
{
    if(m_priv->m_pointcloud)
    {
        return QByteArray(reinterpret_cast<char*>(&m_priv->m_pointcloud->data[0]), m_priv->m_pointcloud->data.size());
        //return QByteArray::fromRawData(reinterpret_cast<const char*>(&m_priv->m_pointcloud->data[0]), m_priv->m_pointcloud->data.size());
    }
    else
    {
        return m_priv->m_data;
    }
}

quint8 QPointcloud::is_dense() const
{
    if(m_priv->m_pointcloud)
    {
        return m_priv->m_pointcloud->is_dense;
    }
    else
    {
        return m_priv->m_is_dense;
    }
}

const QList<QPointfield *> &QPointcloud::getFields()
{
    return m_priv->m_fields;
}

pcl::PCLPointCloud2 *QPointcloud::pointcloud()
{
    if(nullptr == m_priv->m_pointcloud)
    {
        m_priv->m_pointcloud = new pcl::PCLPointCloud2();
    }
    return m_priv->m_pointcloud;
}

void QPointcloud::setPointcloud(const pcl::PCLPointCloud2& copy)
{
    if(m_priv->m_pointcloud != nullptr)
    {
        delete m_priv->m_pointcloud;
    }
    m_priv->m_pointcloud = new pcl::PCLPointCloud2(copy);
}

void QPointcloud::readXyz(QString &path, bool demean, bool normalize, float normalizeScale, bool flipYZ)
{
    // Not yet implemented
}

QVector3D QPointcloud::minimum() const
{
    if(m_priv->m_dirtyMinMax)
    {
        m_priv->updateMinMax();
    }
    return m_priv->m_minimum;
}

QVector3D QPointcloud::maximum() const
{
    if(m_priv->m_dirtyMinMax)
    {
        m_priv->updateMinMax();
    }
    return m_priv->m_maximum;
}

QVector3D QPointcloud::centroid() const
{
    if(m_priv->m_dirtyCentroid)
    {
        m_priv->updateCentroid();
    }
    return m_priv->m_centroid;
}

QVector3D QPointcloud::offset() const
{
    return m_priv->m_offset;
}



void QPointcloud::setHeight(quint32 height)
{
#if WITH_PCL
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->height == height)
            return;
        m_priv->m_pointcloud->height = height;
    }
    else
#endif
    {
        if (m_priv->m_height == height)
            return;
        m_priv->m_height = height;
    }
    Q_EMIT heightChanged(height);
}

void QPointcloud::setWidth(quint32 width)
{
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->width == width)
            return;
        m_priv->m_pointcloud->width = width;
    }
    else
    {
        if (m_priv->m_width == width)
            return;
        m_priv->m_width = width;
    }
    Q_EMIT widthChanged(width);
}

void QPointcloud::setIs_bigendian(quint8 is_bigendian)
{
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->is_bigendian == is_bigendian)
            return;
        m_priv->m_pointcloud->is_bigendian = is_bigendian;
    }
    else
    {
        if (m_priv->m_is_bigendian == is_bigendian)
            return;
        m_priv->m_is_bigendian = is_bigendian;
    }
    Q_EMIT is_bigendianChanged(is_bigendian);
}

void QPointcloud::setPoint_step(quint32 point_step)
{
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->point_step == point_step)
            return;
        m_priv->m_pointcloud->point_step = point_step;
    }
    else
    {
        if (m_priv->m_point_step == point_step)
            return;
        m_priv->m_point_step = point_step;
    }

    Q_EMIT point_stepChanged(point_step);
}

void QPointcloud::setRow_step(quint32 row_step)
{
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->row_step == row_step)
            return;

        m_priv->m_pointcloud->row_step = row_step;
    }
    else
    {
        if (m_priv->m_row_step == row_step)
            return;
        m_priv->m_row_step = row_step;
    }
    Q_EMIT row_stepChanged(row_step);
}

void QPointcloud::setData(QByteArray data)
{
    if(m_priv->m_pointcloud)
    {
        m_priv->m_pointcloud->data.resize(data.size());
        memcpy(&m_priv->m_pointcloud->data[0], data.data(), m_priv->m_pointcloud->data.size());
    }
    else
    {
        m_priv->m_data = data;
    }
    Q_EMIT dataChanged(data);
}

void QPointcloud::setIs_dense(quint8 is_dense)
{
    if(m_priv->m_pointcloud)
    {
        if (m_priv->m_pointcloud->is_dense == is_dense)
            return;

        m_priv->m_pointcloud->is_dense = is_dense;
    }
    else
    {
        if (m_priv->m_is_dense == is_dense)
            return;
        m_priv->m_is_dense = is_dense;
    }
    Q_EMIT is_denseChanged(is_dense);
}
