#ifndef FILEREADWRITE_H
#define FILEREADWRITE_H
#include <QDebug>
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QString>

namespace common {
static bool readFile(const QString &filePath, QByteArray &content){
    QFile file(filePath);
    if (!file.open(QFile::ReadOnly))
    {
        qWarning() << "open file " << filePath << "failed:" << file.errorString();
        return false;
    }
    content = file.readAll();
    file.close();
    return true;
}
static bool readJson(const QByteArray &data, QJsonDocument &doc)
{
    QJsonParseError err;
    doc = QJsonDocument::fromJson(data, &err);
    if (doc.isNull())
    {
        qWarning() << "parse json failed:" << err.errorString();
        return false;
    }
    return true;
}
static bool  readJson(const QByteArray &data, QJsonArray &array)
{
    QJsonDocument doc;
    bool ok = readJson(data, doc);
    if (ok)
    {
        array = doc.array();
    }
//    qDebug() << doc;
//    qDebug() << doc.toJson();
    return ok;
}
static bool readJson(const QByteArray &data, QJsonObject &object)
{
    QJsonDocument doc;
    bool ok = readJson(data, doc);
    if (ok)
    {
        object = doc.object();
    }
    return ok;
}

static bool readJsonFile(const QString &filePath, QJsonDocument &jsonDoc)
{
    QByteArray data;
    if (!readFile(filePath, data))
    {
        return false;
    }
    return readJson(data, jsonDoc);
}
static bool readJsonFile(const QString &filePath, QJsonObject &jsonObj)
{
    QByteArray data;
    if (!readFile(filePath, data))
    {
        return false;
    }
    return readJson(data, jsonObj);
}
static bool readJsonFile(const QString &filePath, QJsonArray &jsonArray)
{
    QByteArray data;
    if (!readFile(filePath, data))
    {

        return false;
    }
    return readJson(data, jsonArray);
}
static bool writeFile(const QString &filePath, const QByteArray &content)
{
    QFile file(filePath);
    if (!file.open(QFile::WriteOnly))
    {
        qWarning() << "open file " << filePath << "failed:" << file.errorString();
        return false;
    }
    file.write(content);
    file.close();
    return true;
}
static bool writeJsonFile(const QString &filePath, const QJsonDocument &doc, bool compact = true)
{
    return writeFile(filePath, doc.toJson(compact ? QJsonDocument::Compact : QJsonDocument::Indented));
}
static bool writeJsonFile(const QString &filePath, const QJsonArray &jsonArray, bool compact = true)
{
    return writeJsonFile(filePath, QJsonDocument(jsonArray), compact);
}
static bool writeJsonFile(const QString &filePath, const QJsonObject &jsonObj, bool compact = true)
{
    return writeJsonFile(filePath, QJsonDocument(jsonObj), compact);
}

}
#endif // FILEREADWRITE_H
