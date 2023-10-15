//直线的单个任务
function getLineTask(line_speed, length){
    return {
        move_type:"line",
        line_speed:line_speed,
        angular_speed:0,
        distance:length,
        rotation_angle:0
    }
}
//自选的单个任务
function getRotationTask(angle_speed, angle){
    return{
        move_type:"rotation",
        line_speed:0,
        angular_speed:angle_speed,
        distance:0,
        rotation_angle:angle
    }
}
//圆周运动的单个任务
function getCircleTask(line_speed, raduis, angle){
    return{
        move_type:"circle",
        line_speed:line_speed,
        angular_speed:line_speed/raduis,
        distance:angle * raduis,
        rotation_angle:angle
    }
}
//根据任务类型,叠加控制任务
function getTask(move_type, line_speed, angle_speed, length, angle){
    var task =[]

    switch(move_type){

    case "直线":
        task =[]
        task.push(getLineTask(line_speed, length))
        break
    case "正方形":
        task =[]
        var lineTask1 = getLineTask(line_speed, length)
        var angleTask1 = getRotationTask(angle_speed, Math.PI *0.5)
        var lineTask2 = getLineTask(line_speed, length)
        var angleTask2 = getRotationTask(angle_speed, Math.PI *0.5)
        var lineTask3 = getLineTask(line_speed, length)
        var angleTask3 = getRotationTask(angle_speed, Math.PI *0.5)
        var lineTask4 = getLineTask(line_speed, length)
        var angleTask4 = getRotationTask(angle_speed, Math.PI *0.5)
        task.push(lineTask1)
        task.push(angleTask1)
        task.push(lineTask2)
        task.push(angleTask2)
        task.push(lineTask3)
        task.push(angleTask3)
        task.push(lineTask4)
        task.push(angleTask4)
        break
    case "圆":
        task =[]
        task.push(getCircleTask(line_speed, length, angle))
        break
    case "自旋":
        task =[]
        task.push(getRotationTask(angle_speed, angle))
        break
    }

    return task
}
