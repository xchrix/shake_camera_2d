class_name ShakeCamera2D
extends Camera2D


## 抖动时长
var _duration = 0.0

## 抖动周期
var _period = 0.0

## 抖动幅度
var _amplitude = 0.0

## 抖动计时器
var _timer = 0.0

## 刷新时间点，记录需计算下一个点的时间按
var _refresh_t:float=0

## 当前周期中的终点位置
var _new_p:Vector2

## 当前周期中的起点位置
var _pre_p:Vector2

## 当前点位置，每帧更新
var _point:Vector2


func _ready():
	set_process(true)


func _process(delta):
	# 抖动结束
	if _timer <= 0:
		# 相机归位
		set_offset(Vector2())
		# 禁用_process回调函数，该函数不再被引擎调用
		set_process(false)
		return

	# 需要更新目标点
	while _timer<=_refresh_t:
		# 计算下一次更新的时间点
		_refresh_t=_refresh_t-_period

		## 更新起点为上一周期终点
		_pre_p=_new_p
		# 计算新点作为终点
		var dir_rad=randf_range(0,TAU)
		_new_p=randf_range(0.0, 1.0)*Vector2(cos(dir_rad),sin(dir_rad))

	# 由起点向终点线性移动
	_point=_pre_p.lerp(_new_p,(_timer-_refresh_t)/_period)
	# 实时幅度，幅度按剩余时间二次方逐渐趋于零
	var intensity = _timer*_timer *(_amplitude / _duration/_duration)
	
	# 根据当前点位置和实时幅度，更新相机偏移
	set_offset(intensity * _point)

	# 更新计时器
	_timer = _timer - delta


## 触发抖动的函数
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
