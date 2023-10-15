#ifndef CADREADER_H
#define CADREADER_H

#include <QString>
#include <QList>
#include <iostream>
#include <QJsonArray>
#include <QJsonObject>
#include <QObject>
#include "dx_data.h"
#include "dx_iface.h"

class CADReader: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filename  WRITE setFilename NOTIFY filenameChanged)
public:
    CADReader();
    ~CADReader();
    bool init(std::string& filePath);
    void parseData(std::list<DRW_Entity*> &all_data);
public Q_SLOTS:
    void setFilename(QString filename);
signals:
    void filenameChanged(QString filename);
    void cadChanged(QJsonObject jsonCad);
private:
    dx_iface* m_iface;

};

#endif // CADREADER_H
