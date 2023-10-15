#include "RoadmapJsonTreeModel.h"
#include "common/FileReadWrite.h"
#include <QJsonArray>

#include <QDebug>

namespace roadmap_manager {

void RoadmapJsonTreeModel::loadFromJson(const QString& jsonPath, const QString& recursionKey)
{
    QJsonArray arr;
    if(jsonPath.endsWith(".json_"))
    {
        if (!common::readJsonFile(jsonPath, arr)) {
            qDebug() << "fail to load json";
            return;
        }
    }
    else if(jsonPath.endsWith(".json"))
    {
//        QJsonObject object;
        common::readJsonFile(jsonPath, m_roadmap);
        jsonObjectToJsonArray(m_roadmap, arr);
        if(!m_route.init(m_roadmap)){
            qDebug() << "fail to init route";
            return;
        }

    }
    m_recursionKey = recursionKey;
    beginResetModel();
    m_nodeList.clear();
    gen(0, arr);

    endResetModel();
    emit loadRoadmapFile();
    emit countChanged();
}
void RoadmapJsonTreeModel::jsonObjectToJsonArray(const QJsonObject& obj, QJsonArray& dataArray)
{
    QJsonObject qjson_nodes,qjson_lanes,qjson_template;
//    qDebug() << obj[""]

    qjson_template["id"] = "段模板";
    if(obj["段模板"].Undefined)
    {
        qDebug() << "Undefined";
        QJsonArray qjson_template_array;
        QJsonObject normol_forward_template,
                normol_backward_template,
                bounnding_template;
        normol_forward_template["id"] = "常规前进";
        normol_forward_template["motion_type"] = 1;
        normol_forward_template["p1"] = 2;
        normol_forward_template["speed"] = 0.5;
        normol_forward_template["template_type"] = "lane";
        qjson_template_array.append(normol_forward_template);
        normol_backward_template["id"] = "常规后退";
        normol_backward_template["motion_type"] = -1;
        normol_backward_template["p1"] = -2;
        normol_backward_template["speed"] = 0.5;
        normol_backward_template["template_type"] = "lane";
        qjson_template_array.append(normol_backward_template);
        bounnding_template["id"] = "模板绑定";
        bounnding_template["subType"];
        qjson_template_array.append(bounnding_template);
        qjson_template["subType"] = qjson_template_array;
    }
    else {
        qjson_template["subType"] =obj["段模板"];
    }

    qjson_nodes["id"] = "nodes";
    qjson_lanes["id"] = "lanes";
    qjson_nodes["subType"] = obj["nodes"];
    qjson_lanes["subType"] = obj["lanes"];
    dataArray.append(qjson_template);
    dataArray.append(qjson_nodes);
    dataArray.append(qjson_lanes);
}
void RoadmapJsonTreeModel::gen(int depth, const QJsonArray& dataArray)
{
    qDebug() << "dataArray.size is " << dataArray.size();
    //一层一层，进行解析，开始是0层
    for (auto i : dataArray) {
        auto obj = i.toObject();
        obj[cDepthKey] = depth;
        obj[cExpendKey] = true;
        obj[cChildrenExpendKey] = false;
        obj[cHasChildendKey] = false;
        if (!m_recursionKey.isEmpty() && obj.contains(m_recursionKey)) {
            auto arr = obj.value(m_recursionKey).toArray();
            if (!arr.isEmpty()) {
                obj[cChildrenExpendKey] = true;
                obj[cHasChildendKey] = true;
                obj.remove(m_recursionKey);
                m_nodeList.append(obj);
                gen(depth + 1, arr);
                continue;
            }
        }
        m_nodeList.append(obj);
//        qDebug() << "m_nodeList.size is " << m_nodeList.size();
    }
//    qDebug() << "m_nodeList.size is " << m_nodeList.size();
}
bool RoadmapJsonTreeModel::saveToJson(const QString& jsonPath, bool compact) const
{
    QJsonObject roadmap;
    QJsonArray arr;
    int depth = 0;
    for (int i = 0; i < m_nodeList.size(); ++i) {
        depth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (depth == 0) {
            auto node = QJsonObject(m_nodeList.at(i));
            for (auto k : cFilterKeyList) {
                node.remove(k);
            }
            auto children = getChildren(i, depth);
            if (!children.isEmpty()) {
                node[m_recursionKey] = children;
            }
            arr.push_back(node);
        }
    }
    for(auto item : arr){
        if(item.toObject()["id"].toString() == "段模板")
        {
            roadmap["段模板"] = item.toObject();
        }
        else if (item.toObject()["id"].toString() == "nodes") {

            roadmap["nodes"] = item.toObject()["subType"];
        }
        else if (item.toObject()["id"].toString() == "lanes") {

            roadmap["lanes"] = item.toObject()["subType"];
        }
    }
//    m_roadmap = roadmap;
    return common::writeJsonFile(jsonPath, roadmap, compact);
}



void RoadmapJsonTreeModel::clear()
{
    beginResetModel();
    m_nodeList.clear();
    endResetModel();
    countChanged();
}
QJsonArray RoadmapJsonTreeModel::getChildren(int parentIndex, int parentDepth) const
{
    QJsonArray arr;
    for (int i = parentIndex + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth == parentDepth + 1) {
            auto node = QJsonObject(m_nodeList.at(i));
            for (auto k : cFilterKeyList) {
                node.remove(k);
            }
            auto children = getChildren(i, childDepth);
            if (!children.isEmpty()) {
                node[m_recursionKey] = children;
            }
            arr.append(node);
        } else if (childDepth <= parentDepth) {
            break;
        }
    }
    return arr;
}
void RoadmapJsonTreeModel::updateRoadmap()
{
    QJsonArray arr;
    QJsonObject roadmap;
    int depth = 0;
    for (int i = 0; i < m_nodeList.size(); ++i) {
        depth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (depth == 0) {
            auto node = QJsonObject(m_nodeList.at(i));
            for (auto k : cFilterKeyList) {
                node.remove(k);
            }
            auto children = getChildren(i, depth);
            if (!children.isEmpty()) {
                node[m_recursionKey] = children;
            }
            arr.push_back(node);
        }
    }
    for(auto item : arr){
        if(item.toObject()["id"].toString() == "段模板")
        {
            roadmap["段模板"] = item.toObject();
        }
        else if (item.toObject()["id"].toString() == "nodes") {

            roadmap["nodes"] = item.toObject()["subType"];
        }
        else if (item.toObject()["id"].toString() == "lanes") {

            roadmap["lanes"] = item.toObject()["subType"];
        }
    }
    m_roadmap = roadmap;

    if(!m_route.init(m_roadmap)){
        qDebug() << "fail to init route";
        return;
    }

}
void RoadmapJsonTreeModel::setNodeValue(int index, const QString& key, const QVariant& value)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
//    if()
    //修改json数组的值
    if (m_nodeList.at(index).value(key).toVariant() != value) {
//        qDebug()<< "index is " << index << "key is " << key;
        m_nodeList[index][key] = QJsonValue::fromVariant(value);
        emit dataChanged(Super::index(index), Super::index(index), { Qt::DisplayRole, Qt::EditRole });
        if(key != cExpendKey)
        {
            emit roadmapDataChanged();

        }
    }
//    qDebug() << m_nodeList[0];
}

//增加节点，相当于一大类数据
int RoadmapJsonTreeModel::addNode(int index, const QJsonObject& json)
{
    //countChanged();
    if (index < 0 || index >= m_nodeList.size()) {
        return addWithoutDepth(json);
    }
    // json数组的深度
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    int i = index + 1;
    for (; i < m_nodeList.size(); ++i) {
        if (m_nodeList.at(i).value(cDepthKey).toInt() <= depth) {
            break;
        }
    }
    auto obj = QJsonObject(json);
    obj[cDepthKey] = depth + 1;
    obj[cExpendKey] = true;
    obj[cChildrenExpendKey] = false;
    obj[cHasChildendKey] = false;
    beginInsertRows(QModelIndex(), i, i);
    m_nodeList.insert(i, obj);
    endInsertRows();
    countChanged();
    innerUpdate(index);
    expandTo(i);
    return i;
}

int RoadmapJsonTreeModel::addWithoutDepth(const QJsonObject& json)
{
    auto obj = QJsonObject(json);
    obj[cDepthKey] = 0;
    obj[cExpendKey] = true;
    obj[cChildrenExpendKey] = false;
    obj[cHasChildendKey] = false;
    beginInsertRows(QModelIndex(), m_nodeList.count(), m_nodeList.count());
    m_nodeList.append(obj);
    endInsertRows();
    countChanged();
    return m_nodeList.count() - 1;
}
void RoadmapJsonTreeModel::innerUpdate(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    int childrenCount = 0;
    for (int i = index + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        } else if (childDepth == depth + 1) {
            childrenCount++;
        }
    }
    setNodeValue(index, cHasChildendKey, childrenCount > 0);
}
void RoadmapJsonTreeModel::remove(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    int i = index + 1;
    for (; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        }
    }
    beginRemoveRows({}, index, i - 1);
    for (int j = 0; j < i - index; ++j) {
        m_nodeList.removeAt(index);
    }
    endRemoveRows();
    countChanged();
    if (depth > 0) {
        for (int j = index - 1; j >= 0; --j) {
            if (depth - 1 == m_nodeList.at(j).value(cDepthKey).toInt()) {
                innerUpdate(j);
                break;
            }
        }
    }
}

QList<int> RoadmapJsonTreeModel::search(const QString& key, const QString& value, Qt::CaseSensitivity cs) const
{
    if (key.isEmpty() || value.isEmpty()) {
        return {};
    }
    QList<int> ans;
    ans.reserve(m_nodeList.size());
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (m_nodeList.at(i).value(key).toString().contains(value, cs)) {
            ans.push_back(i);
        }
    }
    return ans;
}

void RoadmapJsonTreeModel::expand(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    for (int i = index + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        } else if (childDepth > depth + 1) {
            continue;
        }
        setNodeValue(i, cExpendKey, true);
    }
    setNodeValue(index, cChildrenExpendKey, true);
}

void RoadmapJsonTreeModel::collapse(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    for (int i = index + 1; i < m_nodeList.size(); ++i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth <= depth) {
            break;
        }
        setNodeValue(i, cExpendKey, false);
        setNodeValue(i, cChildrenExpendKey, false);
    }
    setNodeValue(index, cChildrenExpendKey, false);
}

void RoadmapJsonTreeModel::expandTo(int index)
{
    if (index < 0 || index >= m_nodeList.size()) {
        return;
    }
    int depth = m_nodeList.at(index).value(cDepthKey).toInt();
    int parentDepth = depth - 1;
    QList<int> indexList;
    for (int i = index - 1; i >= 0 && parentDepth >= 0; --i) {
        int childDepth = m_nodeList.at(i).value(cDepthKey).toInt();
        if (childDepth == parentDepth) {
            indexList.push_back(i);
            parentDepth--;
        }
    }
    for (auto i : indexList) {
        expand(i);
    }
}

void RoadmapJsonTreeModel::expandAll()
{
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (true == m_nodeList.at(i).value(cHasChildendKey).toBool()) {
            setNodeValue(i, cChildrenExpendKey, true);
        }
        setNodeValue(i, cExpendKey, true);
    }
}

void RoadmapJsonTreeModel::collapseAll()
{
    for (int i = 0; i < m_nodeList.size(); ++i) {
        if (true == m_nodeList.at(i).value(cHasChildendKey).toBool()) {
            setNodeValue(i, cChildrenExpendKey, false);
        }
        if (0 < m_nodeList.at(i).value(cDepthKey).toInt()) {
            setNodeValue(i, cExpendKey, false);
        }
    }
}

int RoadmapJsonTreeModel::count() const
{
    return m_nodeList.size();
}

void RoadmapJsonTreeModel::plan(int start_id, int goal_id){
    m_route.plan(start_id, goal_id, m_route_result);
    emit routeResultGet();
}

} // namespace TaoCommon
