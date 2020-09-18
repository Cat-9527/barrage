import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:barrage/barrage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Barrage Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: BarrageSample(),
      ),
    );
  }
}

class BarrageSample extends StatefulWidget {
  const BarrageSample({ Key key }) : super(key: key);

  @override
  BarrageSampleState createState() => BarrageSampleState();
}

class BarrageSampleState extends State<BarrageSample> {
  BarrageWallController _controller;

  Timer _timer;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = BarrageWallController.all(
      options: ChannelOptions(height: 24.0),
      channelCount: 18,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _change() {
    setState(() {
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      _controller.play();
      // 每间隔 300 毫秒添加一条弹幕
      _timer = Timer.periodic(
        const Duration(milliseconds: 300),
        (_) => _addBarrage()
      );
    } else {
      _controller.pause();
      _timer.cancel();
    }
  }

  int _addBarrage() {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _randomIcon,
        const SizedBox(width: 8.0),
        Text(
          _randomWord,
          style: TextStyle(
            fontSize: 17.0,
            color: _randomTextColor(),
          ),
        ),
      ],
    );

    var item = BarrageItem(
      content: content,
      // 随机一个 0.5 到 1.5 之间的滚动速度
      speed: Random().nextDouble() + 0.5,
      start: isPlaying,
    );

    return _controller.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.pink,
          child: _controller.buildView(),
        ),
        RaisedButton(
          child: Text(isPlaying ? 'Pause' : 'Play'),
          onPressed: () => _change(),
        ),
        RaisedButton(
          child: Text('Clear'),
          onPressed: () => _controller.clear(),
        ),
      ],
    );
  }
}

const List<String> _words = <String>[
  "666",
  "给阿姨倒杯卡布奇诺",
  "17张牌他能秒我，我当场吃掉这个显示器",
  "小轩在不在,我是娇妹",
  "蛮王冲撞",
  "醉里挑灯看剑，梦回吹角连营。",
  "你看我还有机会吗？",
  "I will find you, and kill you!",
  "风急天高猿啸哀，渚清沙白鸟飞回。",
  "无边落木萧萧下，不尽长江滚滚来。",
  "万里悲秋常作客，百年多病独登台。",
  "艰难苦恨繁霜鬓",
  "潦倒新停浊酒杯",
];

String get _randomWord => _words[Random().nextInt(_words.length)];

const List<Icon> _icons = <Icon>[
  Icon(Icons.error, color: Colors.blue),
  Icon(Icons.wifi_tethering, color: Colors.green),
  Icon(Icons.video_library, color: Colors.yellow),
  Icon(Icons.extension, color: Colors.purple),
  Icon(Icons.hd, color: Colors.orange),
];

Icon get _randomIcon => _icons[Random().nextInt(_icons.length)];

Color _randomTextColor() {
  return Random().nextInt(10) < 9
      ? Colors.white
      : Colors.yellow;
}
