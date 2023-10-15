#include "qpointfield.h"

#include <pcl/PCLPointField.h>

pcl::uint8_t toPCLDatatype(const QPointfield::PointFieldTypes& datatype)
{
    switch(datatype)
    {
    case QPointfield::INT8:
        return pcl::PCLPointField::INT8;
    case QPointfield::UINT8:
        return pcl::PCLPointField::UINT8;
    case QPointfield::INT16:
        return pcl::PCLPointField::INT16;
    case QPointfield::UINT16:
        return pcl::PCLPointField::UINT16;
    case QPointfield::INT32:
        return pcl::PCLPointField::INT32;
    case QPointfield::UINT32:
        return pcl::PCLPointField::UINT32;
    case QPointfield::FLOAT32:
        return pcl::PCLPointField::FLOAT32;
    case QPointfield::FLOAT64:
        return pcl::PCLPointField::FLOAT64;
    }
    Q_ASSERT_X(false, "fromPCLDatatype", "unknown PCL pointfield");
    return pcl::PCLPointField::INT8;
}
QPointfield::PointFieldTypes fromPCLDatatype(const pcl::uint8_t &datatype)
{
    switch(datatype)
    {
    case pcl::PCLPointField::INT8:
        return QPointfield::INT8;
    case pcl::PCLPointField::UINT8:
        return QPointfield::UINT8;
    case pcl::PCLPointField::INT16:
        return QPointfield::INT16;
    case pcl::PCLPointField::UINT16:
        return QPointfield::UINT16;
    case pcl::PCLPointField::INT32:
        return QPointfield::INT32;
    case pcl::PCLPointField::UINT32:
        return QPointfield::UINT32;
    case pcl::PCLPointField::FLOAT32:
        return QPointfield::FLOAT32;
    case pcl::PCLPointField::FLOAT64:
        return QPointfield::FLOAT64;
    }
    Q_ASSERT_X(false, "toPCLDatatype", "unknown pointfield");
    return QPointfield::INT8;
}

QPointfield::QPointfield(QObject *parent, pcl::PCLPointField *field)
    :QObject(parent)
    ,m_name(field->name.c_str())
    ,m_offset(field->offset)
    ,m_datatype(fromPCLDatatype(field->datatype))
    ,m_count(field->count)
    ,m_pointfield(field)
{
}

QPointfield::QPointfield(pcl::PCLPointField *field)
    :m_name(field->name.c_str())
    ,m_offset(field->offset)
    ,m_datatype(fromPCLDatatype(field->datatype))
    ,m_count(field->count)
    ,m_pointfield(field)
{
}

QPointfield::QPointfield(QObject *parent, QString name, quint32 offset, PointFieldTypes type, quint32 count)
    :QObject(parent)
    ,m_name(name)
    ,m_offset(offset)
    ,m_datatype(type)
    ,m_count(count)
    #if WITH_PCL
    // Note, there is no way to obtain a pcl point field, if it is not given in constructor.
    ,m_pointfield(nullptr)
    #endif
{
}

QString QPointfield::name() const
{
    return m_name;
}

quint32 QPointfield::offset() const
{
    return m_offset;
}

QPointfield::PointFieldTypes QPointfield::datatype() const
{
    return m_datatype;
}

quint32 QPointfield::count() const
{
    return m_count;
}

void QPointfield::setName(QString name)
{
    if (m_name == name)
        return;
    m_name = name;
    if(m_pointfield)
    {
        std::string stdname(name.toStdString());
        m_pointfield->name = stdname;
    }
    Q_EMIT nameChanged(name);
}

void QPointfield::setOffset(quint32 offset)
{
    if (m_offset == offset)
        return;
    m_offset = offset;
    if(m_pointfield)
    {
        m_pointfield->offset = offset;
    }
    Q_EMIT offsetChanged(offset);
}

void QPointfield::setDatatype(QPointfield::PointFieldTypes datatype)
{
    if (m_datatype == datatype)
        return;
    m_datatype = datatype;
    if(m_pointfield)
    {
        m_pointfield->datatype = toPCLDatatype(datatype);
    }
    Q_EMIT datatypeChanged(datatype);
}

void QPointfield::setCount(quint32 count)
{
    if (m_count == count)
        return;
    m_count = count;
    if(m_pointfield)
    {
        m_pointfield->count = count;
    }
    Q_EMIT countChanged(count);
}
