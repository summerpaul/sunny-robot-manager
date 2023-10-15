import QtQuick 2.0
import QtCharts 2.3

ChartView{
    id:chartView
    ValueAxis{
        id:axisx
    }
    ValueAxis{
        id:axisy
        max:1;
        min:-1;
    }
    LineSeries {
        id: lineSeries1
        name: "横向偏差"
        axisX: axisx
        axisY: axisy

    }
    LineSeries {
        id: lineSeries2
        name: "角度偏差"
        axisX: axisx
        axisY: axisy
    }

}
