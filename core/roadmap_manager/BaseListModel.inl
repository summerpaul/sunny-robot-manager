#pragma once
#include <QtDebug>
namespace roadmap_manager {
template <typename T>
BaseListModel<T>::BaseListModel(QObject* parent)
    : Super(parent)
{
}

template <typename T>
BaseListModel<T>::BaseListModel(const QList<T>& nodeList, QObject* parent)
    : Super(parent)
    , m_nodeList(nodeList)
{
}
template <typename T>
Qt::ItemFlags BaseListModel<T>::flags(const QModelIndex& index) const
{
    if (!index.isValid())
        return Super::flags(index) | Qt::ItemIsDropEnabled;

    return Super::flags(index) | Qt::ItemIsEditable | Qt::ItemIsDragEnabled | Qt::ItemIsDropEnabled;
}

template <typename T>
void BaseListModel<T>::setNodeList(const QList<T>& nodeList)
{
    beginResetModel();
    m_nodeList = nodeList;
    endResetModel();
}

template <typename T>
int BaseListModel<T>::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return m_nodeList.count();
}
template <typename T>
QVariant BaseListModel<T>::data(const QModelIndex& index, int role) const
{
    if (index.row() < 0 || index.row() >= m_nodeList.size())
        return {};

    if (role == Qt::DisplayRole || role == Qt::EditRole)
    {
//        qDebug() << m_nodeList.at(index.row());
        return m_nodeList.at(index.row());
    }

    return {};
}
template <typename T>
bool BaseListModel<T>::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (index.row() >= 0 && index.row() < m_nodeList.size() && (role == Qt::EditRole || role == Qt::DisplayRole)) {
        auto realValue = value.value<T>();
        if (m_nodeList.at(index.row()) == realValue)
            return true;
        m_nodeList.replace(index.row(), realValue);
        emit dataChanged(index, index, { Qt::DisplayRole, Qt::EditRole });
        return true;
    }
    return false;
}


template <typename T>
bool BaseListModel<T>::insertRows(int row, int count, const QModelIndex& parent)
{
    if (count < 1 || row < 0 || row > rowCount(parent)) {
        return false;
    }
    beginInsertRows(QModelIndex(), row, row + count - 1);
    for (int i = 0; i < count; ++i) {
        m_nodeList.insert(row, T {});
    }
    endInsertRows();
    return true;
}

template <typename T>
bool BaseListModel<T>::removeRows(int row, int count, const QModelIndex& parent)
{
    if (count <= 0 || row < 0 || (row + count) > rowCount(parent)) {
        return false;
    }
    beginRemoveRows(QModelIndex(), row, row + count - 1);
    for (int i = 0; i < count; ++i) {
        m_nodeList.removeAt(row);
    }
    endRemoveRows();
    return true;
}

template <typename T>
Qt::DropActions BaseListModel<T>::supportedDropActions() const
{
    return Super::supportedDropActions() | Qt::MoveAction;
}
} // namespace TaoCommon
