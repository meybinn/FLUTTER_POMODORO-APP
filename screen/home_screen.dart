import 'dart:async'; // Timer 사용에 필요
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 혹시 모를 실수를 방지하기 위해 1500(초)를 static const 변수로 선언
  static const twentyFiveMinutes = 1500;
  int totalSeconds = 10;
  late Timer timer;
  bool isRunning = false;
  int totalPomodoros = 0;

// build 위에 메소드들을 정의했더니 오류 개 많이 남 -> 다 override한 메소드 아래에 정의
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                // SizedBox 대신 main~ 넣으면 공백말고 그냥 정렬 가능
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 150,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                  ),

                  // reset 버튼 (시간 & POMODOROS 다 0으로 리셋)
                  IconButton(
                      iconSize: 50,
                      color: Theme.of(context).cardColor,
                      onPressed: onResetPressed,
                      icon: const Icon(Icons.reset_tv_outlined))
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color ??
                                Colors.black,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color ??
                                Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 타이머를 초기화하는 함수 (기능 : state 변경 = 메 초마다 실행)
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else
      setState(() {
        // setState에 값을 넣을 때 잘 넣어야 함... 메소드 호출 방식으로 작성해야 함
        // 메소드 호출 방식+
        totalSeconds = totalSeconds - 1;
      });
  }

  // Timer가 매 초마다 onTIck이라는 함수를 실행하도록 돕는 함수
  void onStartPressed() {
    // onTick에 괄호 안넣음 -> 괄호 = 함수 실행을 의미
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalPomodoros = 0;
      totalSeconds = 1500;
    });
  }

// 1500(초 단위)를 25(분 단위)로 바꿔주는 메소드
// Durarion : seconds 값을Dart에서 다룰 수 있는 시간 객체로 변환(시간 간격(초, 분, 시간)을 계산/다른 시간 간격과 비교)
// ㄴ Duration(seconds: 1500) = 25분에 해당하는 시간 객체를 생성
// ㄴ duration.toString() = Duration 객체를 "HH:MM:SS" 형식의 문자열로 변환
// ㄴ substring(2, 7) = index 2(='2')부터 index 7 이전(='0')까지
  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    // (시간:분:초)로 디버그 콘솔에 출력
    // duration을 문자열로 바꿈 & . 기준으로 분리 & 분리된 것 중에서 첫번째만 출력
    return duration.toString().split(".").first.substring(2, 7);
  }
}
