# Godot 4 Shake Camera2D

Godot 4 的抖动相机代码，可以用于2D游戏中表示角色受到攻击时的镜头语言，可以配合自己的shader做出更加丰富的效果。

## Install & Usage

将`shake_camera2d.gd`拷贝至自己的项目，在场景树中相机父节点处`Ctrl + A`添加子节点`ShakeCamera2D`，在需要抖动相机时通过信号调用或直接调用`ShakeCamera2D`节点的`shake`函数。

示例场景中`Button`节点的`pressed`信号便通过带参数的方式调用了`shake`函数。`F6`运行场景，点击`Shake`按钮即可观察到抖动效果。

## License

MIT (c) xchrix
