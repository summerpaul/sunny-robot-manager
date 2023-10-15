#include "cadreader.h"
CADReader::CADReader(){
}

CADReader::~CADReader(){
    delete m_iface;
}

void CADReader::setFilename(QString filename){
    m_iface = new dx_iface();
    dx_data fData;
    if(!m_iface->fileImport(filename.toStdString(), &fData)){
        return;
    }
    parseData(fData.mBlock->ent);
    emit filenameChanged(filename);

}
bool CADReader::init(std::string& filePath)
{
    m_iface = new dx_iface();
    dx_data fData;
    if(!m_iface->fileImport(filePath, &fData)){
        std::cout << "Error to read file " << filePath << std::endl;
        return false;
    }
    parseData(fData.mBlock->ent);
    return true;
}

void CADReader::parseData(std::list<DRW_Entity*> &all_data){
    if(all_data.size() == 0){
        std::cout << "cad data is empty! " << std::endl;
        return;
    }
    QJsonArray qlines_array, qpolyline_array;
    QJsonObject qjson_line, qpoly_line_point;
    for(auto one_cad_item:all_data){
        if ( one_cad_item->eType == DRW::LINE){
            DRW_Line *line = dynamic_cast<DRW_Line *>(one_cad_item);
            QJsonObject qjson_line;
            qjson_line["x1"] = line->basePoint.x * 0.001;
            qjson_line["y1"] = line->basePoint.y * 0.001;
            qjson_line["z1"] = line->basePoint.z * 0.001;
            qjson_line["x2"] = line->secPoint.x * 0.001;
            qjson_line["y2"] = line->secPoint.y * 0.001;
            qjson_line["z2"] = line->secPoint.z * 0.001;
            qlines_array.append(qjson_line);
        }
        if( one_cad_item->eType== DRW::LWPOLYLINE){
            DRW_LWPolyline* polyLine =  dynamic_cast<DRW_LWPolyline *>(one_cad_item);
            QJsonArray qpolyline;
            for (auto polyline_point: polyLine->vertlist){
                qpoly_line_point["x"] = polyline_point->x * 0.001;
                qpoly_line_point["y"] = polyline_point->y * 0.001;
                qpolyline.append(qpoly_line_point);
            }
            qpolyline_array.append(qpolyline);
        }
    }
    QJsonObject json_cad;
    json_cad["lines"] = qlines_array;
    json_cad["polylines"] = qpolyline_array;
    emit cadChanged(json_cad);

}

