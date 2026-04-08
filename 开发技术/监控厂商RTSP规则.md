# 监控厂商RTSP规则

### 大华

> 大华产品
> 

```
rtsp://username:password@ip:port/cam/realmonitor?channel=1&subtype=0

- username: 用户名
- password: 密码
- ip: 为设备IP
- port: 端口号默认为554，默认554时可不填写
- channel: 通道号，起始为1。例如通道2，则为channel=2
- subtype: 码流类型，主码流（subtype=0），辅码流（subtype=1）

`示例： rtsp://admin:admin@127.0.0.1:554/cam/realmonitor?channel=1&subtype=0`

```

### 海康

> 海康-预览取流-旧版规则（2012年之前的设备只持旧版规则）
> 

```
rtsp://<username>:<password>@<ipaddress>:<port>/<videotype>/ch<id>/<streamtype>/av_stream

- username: 用户名
- password: 密码
- ipaddress: 设备IP
- port: 端口号默认为554，默认可不填写
- videotype：视频编码格式，如：h264、mpeg4
- ch: 通道号，起始为1。例如通道1，则为ch1
- streamtype: 码流类型，主码流（main），辅码流（sub）

`示例： rtsp://admin:admin@127.0.0.1:554/h264/ch1/main/av_stream`

`示例： rtsp://admin:admin@127.0.0.1:554/mpeg4/ch2/sub/av_stream`

```

> 海康-预览取流-新版规则
> 

```
rtsp://<username>:<password>@<ipaddress>:<port>/Streaming/Channels/<id>(?parm1=value1&parm2=value2)

- username: 用户名
- password: 密码
- ipaddress: 设备IP
- port: 端口号默认为554，默认可不填写
- id：**通道号+0+码流类型** 码流类型：1-主码流、2-子码流、3-第三码流；如 1202 表示**第12通道子码流**
- parms 其他入参 如 transportmode=unicast (默认单播）transportmode=multicast (多播)

`示例：rtsp://admin:admin@127.0.0.1:554/Streaming/Channels/101`

```

> 海康-回放取流
> 

```
rtsp://<username>:<password>@<ipaddress>:<port>/Streaming/tracks/<id>(?parm1=value1&parm2=value2)

- username: 用户名
- password: 密码
- ipaddress: 设备IP
- port: 端口号默认为554，默认可不填写
- id：**通道号+0+码流类型** 码流类型：1-主码流、2-子码流、3-第三码流；如 1202 表示**第12通道子码流**
- parms 其他入参 如 starttime=20131013t093812z&endtime=20131013t104816z ；具体格式是YYYYMMDD”T”HHmmSS.fraction”Z”，Y是年，M是月，D是日，T是时间分格符，H是小时，M是分，S是秒，Z是可选的、表示Zulu(GMT) 时间

`示例：rtsp://admin:admin@127.0.0.1:554/Streaming/tracks/101?starttime=20180902t123812z&endtime=20180902t124816z`

```

### 宇视

> 宇视摄像头
> 

```
rtsp://用户名:密码@ip:port/video1/2/3 , 分别对应主/辅/三码流

`主码流示例： rtsp://admin:admin@192.168.8.8:554/video1`

```

> 宇视NVR
> 

```
rtsp://用户名:密码@ip:port/unicast/c<channel number>/s<stream type>/live

`<channel number>: 1-n`

`<stream type>: 0（主流），1（辅流）`

`通道1主码流示例： rtsp://admin:admin@192.168.8.7:554/unicast/c1/s0/live`

rtsp://admin:admin@10.12.10.80:554/unicast/c1/s1/live

```

### 华为

> 华为产品
> 

```
rtsp://用户名:密码@ip:port/LiveMedia/ch1/Media1 , Media1代表主码流 Media2代表子流

`主码流示例： rtsp://admin:admin@192.168.2.98:554/LiveMedia/ch1/Media1`

`Onvif地址示例： http://192.168.2.98/onvif/device_service`
```