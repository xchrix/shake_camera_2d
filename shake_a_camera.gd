class_name ShakeACamera
extends Node
## A simple camera shake effect.
## 一个简单的相机抖动效果
## 
## 使用方法：
## 1. 将该脚本挂载到相机节点上，该脚本自动获取Camera2D父节点的引用
## 2. 调用shake(duration, frequency, amplitude)函数触发抖动

## 指向相机的引用
## reference to the camera
@onready var camera_2d: Camera2D = $".."

## 抖动时长（秒）
## shake duration in seconds
var _duration = 0.0

## 抖动周期（秒）
## shake period in seconds
var _period = 0.0

## 抖动幅度（像素）
## shake amplitude in pixels
var _amplitude = 0.0

## 抖动计时器（秒）
## shake timer in seconds
var _timer = 0.0

## 刷新时间点（秒），记录需计算下一个点的时间点
## refresh time point in seconds, record the time point to calculate next point
var _refresh_t:float=0

## 当前周期中的终点位置
## end point in current period
var _new_p:Vector2

## 当前周期中的起点位置
## start point in current period
var _pre_p:Vector2

## 当前点位置，每帧更新
## current point, update every frame
var _point:Vector2


func _ready():
	set_process(true)


func _process(delta):
	# 抖动结束
	if _timer <= 0:
		# 相机归位
		camera_2d.set_offset(Vector2())
		# 禁用_process回调函数，该函数不再被引擎调用
		set_process(false)
		return

	# 需要更新目标点
	# need to update target point
	while _timer<=_refresh_t:
		# 计算下一次更新的时间点
		# calculate next refresh time point
		_refresh_t=_refresh_t-_period

		# 更新起点为上一周期终点
		# update start point as end point in last period
		_pre_p=_new_p
		# 计算新点作为终点，随机方向，随机距离
		# calculate new point as end point, random direction, random distance
		var dir_rad=randf_range(0,TAU)
		_new_p=randf_range(0.0, 1.0)*Vector2(cos(dir_rad),sin(dir_rad))

	# 由起点向终点线性移动
	# lerp from start point to end point
	_point=_pre_p.lerp(_new_p,(_timer-_refresh_t)/_period)
	# 实时幅度，幅度按剩余时间二次方逐渐趋于零
	# intensity, amplitude decreases as time goes by
	var intensity = _timer *(_amplitude / _duration/_duration)
	
	# 根据当前点位置和实时幅度，更新相机偏移,
	# update camera offset according to current point and intensity
	camera_2d.set_offset(intensity * _point)

	# 更新计时器
	# update timer
	_timer = _timer - delta


## 触发抖动的函数
## [code] shake(duration, frequency, amplitude) [/code]
## duration: 抖动时长（秒），shake duration in seconds
## frequency: 抖动频率（Hz），shake frequency in Hz
## amplitude: 抖动幅度（像素），shake amplitude in pixels
func shake(duration, frequency, amplitude) -> void:
	# 如果正在抖动，则不打断正在进行的抖动
	if( _timer > 0):
		return

	# 初始化
	_duration = duration
	_timer = duration
	_period = 1.0 / frequency
	_amplitude = amplitude
	_new_p=Vector2(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0))
	_refresh_t=_timer-_period/2
	_point+=_new_p/2
	# 启动_process回调函数，该函数将被引擎每帧自动调用
	set_process(true)
