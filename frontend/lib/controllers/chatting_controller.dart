import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_matching/config.dart';
import 'package:frontend_matching/controllers/user_data_controller.dart';
import 'package:frontend_matching/models/big_category.dart';
import 'package:frontend_matching/models/chat.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import '../models/event.dart';
import '../models/small_category.dart';
import '../services/time_convert_service.dart';

class ChattingController extends GetxController with WidgetsBindingObserver {
  static ChattingController get to => Get.find<ChattingController>();

  ChattingController({
    required this.roomId,
    required this.isChatEnabled,
    required this.isReceivedRequest,
  });

  static String? baseUrl = AppConfig.baseUrl;
  ScrollController scrollController = ScrollController();
  String? roomId;
  RxString oppUserName=''.obs;

  IO.Socket? _socket; //소켓IO 객체
  RxList chats = [].obs; //채팅 객체를 담는 배열
  Rx<Event?> eventData = Rx<Event?>(null); // event 객체 하나를 담는 변수

  RxBool clickAddButton = false.obs; // +버튼 누름여부
  RxBool showSecondGridView = false.obs; // 두번째 카테고리 여부
  RxInt clickQuizButtonIndex = (-1).obs; // 퀴즈 페이지 button index
  RxBool isReceivedRequest = true.obs; //받은 요청이면 true, 보낸 요청이면 false
  RxBool isChatEnabled = true.obs; //채팅 가능 여부(친구가 아니면 채팅X)
  RxBool isQuizAnswered = false.obs; //퀴즈 답변 여부 ->
  RxBool isChatLoading = false.obs; //채팅 로딩 중인지 여부

  RxString userChoice = "".obs;
  RxString oppUserChoice = "".obs;

  List<dynamic> bigCategories = []; //퀴즈 상위 카테고리
  List<dynamic> smallCategories = []; // 퀴즈 하위 카테고리

  String? bigCategoryName;
  String? chatDate; // 없앨거
  String? lastChatDate; // 최근 채팅 날짜 정보
  String? lastChatUserEmail;
  String? firstChatDate; // 가장 최신 채팅 내용 정보
  String? firstChatUserEmail;

  static const rooms = 'rooms';
  static const send = 'send';
  static const delete = 'delete';
  static const events = 'events';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // Observer 추가
    scrollController.addListener(_onScroll);
    print("ChattingController 생성");
  }

  @override
  void onClose() {
    chats.clear();
    WidgetsBinding.instance.removeObserver(this); // Observer 제거
    if (_socket != null) {
      _socket!.disconnect();
    }
    print("ChattingController 종료");
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // 앱이 포그라운드로 돌아왔을 때
        print("앱 라이프사이클 : resumed(포그라운드)");
        // FCM
        if (_socket!.connected) {
          print("소켓 연결되어 있음 : $roomId");
          chats.clear();
          leaveRoom();
          ChattingController.to.lastChatDate = null;
          getRoomChats(roomId: roomId!);
          joinRoom(roomId: roomId!);
        } else {
          chats.clear();
          ChattingController.to.lastChatDate = null;
          fetchInitialMessages(roomId: roomId.toString());
        }
        break;
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 갔을 때
        print("앱 라이프사이클 : paused(백그라운드)");
        if (_socket != null) {
          _socket!.disconnect();
        }
        break;
      case AppLifecycleState.detached:
        print("앱 라이프사이클 : detached");
        break;
      case AppLifecycleState.hidden:
        print("앱 라이프사이클 : hidden");
        break;
      // 위에 상단바 내렸을 때
      case AppLifecycleState.inactive:
        print("앱 라이프사이클 : inactive(상태바 내렸을떄)");
        break;
      default:
        print(AppLifecycleState);
        break;
    }
  }

  void _onScroll() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isChatLoading.value) {
      print("채팅 가져오기");
      await getRoomChats(roomId: roomId!);
    }
  }

  void setRoomId({required String roomId}) {
    this.roomId = roomId;
  }

  //Socket.io 관련 함수

  /// 소켓 객체 정의
  Future<void> initSocket() async {
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'], //전송 방식을 웹소켓으로 설정
      'autoConnect': false, //수동으로 연결해야함
      'auth': {'token': UserDataController.to.accessToken},
    });
    if (UserDataController.to.accessToken != _socket!.auth['token']) {
      _socket!.auth['token'] = UserDataController.to.accessToken;
      print("토큰 값 변경 : ${_socket!.auth['token']}");
    }
  }

  /// 초기 톡방 내용 가져오기
  void fetchInitialMessages({required String roomId}) async {
    // 채팅방 내용 가져오기
    await getRoomChats(roomId: roomId);
    await initSocket();
    await ChattingController.to.connect(roomId: roomId);
  }

  /// 웹 소켓 연결
  Future<void> connect({required String roomId}) async {
    print("소켓 연결시도");

    if (_socket == null) {
      print("소켓 객체 생성 실패");
    } else {
      print("소켓 객체 생성 성공 : $roomId");
    }

    //소켓 연결
    _socket!.connect();
    //소켓 연결되면 소켓 이벤트 리스너 설정하기
    // _socket!.onConnect((_) {
    //   print("연결 완료");
    //
    // });
    _initSocketListeners();

    joinRoom(roomId: roomId);

    _socket!.onConnectError((data) {
      print("Failed to connect to the server: $data");
    });

    // 소켓 연결 중 에러 발생 시
    _socket!.onError((data) {
      print("An error occurred: $data");
    });
  }

  // 소켓 리스너 초기 설정
  void _initSocketListeners() {
    if(_socket==null){
      _socket= IO.io(baseUrl, <String, dynamic>{
        'transports': ['websocket'], //전송 방식을 웹소켓으로 설정
        'autoConnect': false, //수동으로 연결해야함
        'auth': {'token': UserDataController.to.accessToken},
      });
      if (UserDataController.to.accessToken != _socket!.auth['token']) {
        _socket!.auth['token'] = UserDataController.to.accessToken;
        print("토큰 값 변경 : ${_socket!.auth['token']}");
      }
    }
    var socket=_socket!;

    // //리스너가 중복되어 실행되지 않게 설정
    socket.off("disconnect");
    socket.off("connect");
    socket.off("user join in room");
    socket.off("new message");
    socket.off("delete message");
    socket.off("new event");
    socket.off("answer to event");
    socket.off("leave room");

    // 소켓 'connect' 이벤트 listen
    socket.on("connect", (_) {
      print("소켓이 연결되었습니다.");
    });

    // 'user join in room' 이벤트 listen
    socket.on("user join in room", (data) {
      print(data);
      print("user join in room 도착");
      print("접속한 방 아이디 : $roomId");

      // 안 읽은 채팅 1->0 으로 변환
      String joinUserEmail = data['userEmail'];
      for (Chat chat in chats) {
        if (chat.userEmail != joinUserEmail) {
          chat.readCount.value = 0;
        }
      }
    });

    // 'new message' 이벤트 listen
    socket.on("new message", (data) {
      print(data);
      print("new message 도착");
      print(UserDataController.to.user.value!.nickname);

      if (ChattingController.to.firstChatDate != null &&
          extractDateOnly(ChattingController.to.firstChatDate.toString()) ==
              extractDateOnly(data['msg']['createdAt'])) {
        // 최근 채팅과 새로운 채팅을 입력한 사람이 같다면
        if (ChattingController.to.firstChatDate != null &&
            ChattingController.to.firstChatUserEmail ==
                data['msg']['userEmail']) {
          // 최근 채팅과 새로운 채팅을 입력한 시간이 같다면
          if (ChattingController.to.firstChatDate != null &&
              extractDateTime(ChattingController.to.firstChatDate.toString()) ==
                  extractDateTime(data['msg']['createdAt'])) {
            // 채팅 옆에 날짜 안보이게 하기
            ChattingController.to.firstChatDate = data['msg']['createdAt'];
            ChattingController.to.firstChatUserEmail = data['msg']['userEmail'];
            chats.first.isVisibleDate.value = false;
            chats.insert(0, Chat.fromJson(data['msg']));
          } else {
            ChattingController.to.firstChatDate = data['msg']['createdAt'];
            ChattingController.to.firstChatUserEmail = data['msg']['userEmail'];
            chats.insert(0, Chat.fromJson(data['msg']));
          }
        } else {
          ChattingController.to.firstChatDate = data['msg']['createdAt'];
          ChattingController.to.firstChatUserEmail = data['msg']['userEmail'];
          chats.insert(0, Chat.fromJson(data['msg']));
        }
      }
      // 최근 채팅과 새로운 채팅의 날짜가 다르면
      else {
        // TimeBox 추가
        chats.insert(
            0,
            Chat(
              id: 0,
              roomId: data['msg']['roomId'],
              createdAt: data['msg']['createdAt'],
              content: "timeBox",
              readCount: 0,
              type: 'time',
            ));
        print("타임 박스 추가 ${data['msg']['createdAt']}");
        ChattingController.to.firstChatDate = data['msg']['createdAt'];
        ChattingController.to.firstChatUserEmail = data['msg']['userEmail'];
        chats.insert(0, Chat.fromJson(data['msg']));
      }
    });

    // 'new event' 이벤트 listen
    socket.on("new event", (data) {
      print(data);
      print("밸런스 게임 성공적으로 전송");
      chats.insert(0, Chat.fromJson(data['msg']));
    });

    // 'answer to event' 이벤트 listen
    socket.on("answer to event", (data) {
      print(data);
      print("밸런스 게임 답변 받음");
      String nullValue="아직 선택하지 않았습니다"; // 답변하지 않았을 때 기본 값

      // 받은 이벤트 id가 컨트롤러 안에 있는 이벤트 id와 같으면 변경 -> UI 실시간 변경 가능
      // 보낸 사람의
      if (UserDataController.to.user.value!.nickname ==
              data['event']['user1'] &&
          data['event']['user1Choice'] != nullValue) {
        if (eventData.value!.id == data['event']['id']) {
          eventData.value!.user1Choice.value = data['event']['user1Choice'];
          eventData.value!.user2Choice.value = data['event']['user2Choice'];
          ChattingController.to.isQuizAnswered.value = true;
        }
      }
      else if (UserDataController.to.user.value!.nickname ==
              data['event']['user2'] &&
          data['event']['user2Choice'] != nullValue) {
        if (eventData.value!.id == data['event']['id']) {
          eventData.value!.user1Choice.value = data['event']['user1Choice'];
          eventData.value!.user2Choice.value = data['event']['user2Choice'];
          ChattingController.to.isQuizAnswered.value = true;
        }
      }
      if (ChattingController.to.isQuizAnswered.value) {
        print("답변한 상태에서 이벤트 받기");
        eventData.value!.user1Choice.value = data['event']['user1Choice'];
        eventData.value!.user2Choice.value = data['event']['user2Choice'];
      }
    });

    // 'delete message' 이벤트 listen
    socket.on("delete message", (data) {
      for (Chat chat in chats) {
        if (chat.id == data['msg']['id']) {
          chat.content.value = data['msg']['content'];
          print("삭제 완료");
        }
      }
      print(data);
      print("delete message 도착");
    });

    // 'disconnect' 이벤트 listen
    socket.on("leave room", (data) {
      print(data);
    });

    // 'disconnect' 이벤트 listen
    socket.on("disconnect", (_) {
      print("소켓 연결 끊김");
    });
  }

  //소켓 연결 끊기
  void disconnect() {
    _socket!.disconnect();
  }

  // 채팅방 입장
  void joinRoom({required String roomId}) {
    final data = {
      "roomId": roomId,
    };
    final socket = _socket!;

    socket.emit("join room", data);
  }

  //채팅 보내기
  void sendMessage({
    required String roomId,
    required String content,
  }) {
    final socket = _socket!;

    final data = {
      "roomId": roomId,
      "content": content,
    };
    socket.emit("send message", data);
  }

  //채팅 삭제
  void deleteMessage({
    required String roomId,
    required int chatId,
  }) {
    final socket = _socket!;

    final data = {
      "roomId": roomId,
      "chatId": chatId,
    };
    socket.emit("delete message", data);
  }

  // 새로운 이벤트(밸런스 게임)보내기
  void newEvent({
    required String smallCategoryName,
  }) {
    final socket = _socket!;

    final data = {
      "smallCategory": smallCategoryName,
    };
    socket.emit("new event", data);
  }

  // 이벤트(밸런스 게임) 답변 보내기
  void answerToEvent({
    required int eventId,
    required String selectedContent,
  }) {
    final socket = _socket!;

    final data = {
      "eventId": eventId,
      "content": selectedContent,
    };
    socket.emit("answer to event", data);
  }
  
  /// 채팅방 나가기(소켓상)
  void leaveRoom(){
    final socket = _socket!;
    
    socket.emit("leave room");
  }

  void clickQuizButton(int index) {
    clickQuizButtonIndex.value = index;
  }

  // 채팅 관련 http 메소드

  /// roomId를 통해 해당 방의 채팅 내역 받아오기
  static Future<void> getRoomChats({required String roomId}) async {
    var url;
    ChattingController.to.isChatLoading.value = true;

    // 채팅방 무한 스크롤
    if (ChattingController.to.chats.isNotEmpty) {
      print("===채팅방 무한 스크롤===");
      final firstChatId = ChattingController.to.chats.last.id.toString();
      print(firstChatId);
      url = Uri.parse('$baseUrl/chats/get-chats/$roomId?chatId=$firstChatId');
    }
    // 채팅방 첫입장
    else {
      print("===채팅방 첫 입장===");
      url = Uri.parse('$baseUrl/chats/get-chats/$roomId');
    }

    print("URL : $url");

    // http로 정보 받기
    var response = await UserDataController.sendHttpRequestWithTokenManagement(
        method: 'get', url: url);

    if (response.statusCode == 200) {
      print("채팅 가져올때 사용 토큰 : ${UserDataController.to.accessToken}");
      print(response.body);
      // 받은 정보로 데이터 추가하기
      final jsonData = json.decode(response.body);
      if (jsonData['chats'] != null) {
        for (var data in jsonData['chats']) {
          if (ChattingController.to.lastChatDate == null) {
            ChattingController.to.chats.add(Chat.fromJson(data));
            ChattingController.to.lastChatDate =
                data['createdAt']; // null 일 경우 최근 채팅의 날짜 정보
            ChattingController.to.lastChatUserEmail =
                data['userEmail']; // null 일 경우 최근 채팅의 유저 이메일
          } else {
            // 최근 채팅과 새로운 채팅의 날짜가 같으면
            if (extractDateOnly(ChattingController.to.lastChatDate!) ==
                extractDateOnly(data['createdAt'])) {
              // 최근 채팅과 새로운 채팅을 입력한 사람이 같다면
              if (ChattingController.to.lastChatUserEmail ==
                  data['userEmail']) {
                // 최근 채팅과 새로운 채팅을 입력한 시간이 같다면
                if (extractDateTime(ChattingController.to.lastChatDate!) ==
                    extractDateTime(data['createdAt'])) {
                  // 채팅 옆에 날짜 안보이게 하기
                  ChattingController.to.lastChatDate = data['createdAt'];
                  ChattingController.to.lastChatUserEmail = data['userEmail'];
                  var chat = Chat.fromJson(data);
                  chat.isVisibleDate.value = false;
                  ChattingController.to.chats.add(chat);
                } else {
                  ChattingController.to.lastChatDate = data['createdAt'];
                  ChattingController.to.lastChatUserEmail = data['userEmail'];
                  ChattingController.to.chats.add(Chat.fromJson(data));
                }
              } else {
                ChattingController.to.lastChatDate = data['createdAt'];
                ChattingController.to.lastChatUserEmail = data['userEmail'];
                ChattingController.to.chats.add(Chat.fromJson(data));
              }
            }
            // 최근 채팅과 새로운 채팅의 날짜가 다르면
            else {
              // TimeBox 추가
              ChattingController.to.chats.add(Chat(
                id: 0,
                roomId: data['roomId'],
                createdAt: ChattingController.to.lastChatDate!,
                content: "timeBox",
                readCount: 0,
                type: 'time',
              ));
              print("타임 박스 추가 ${ChattingController.to.lastChatDate!}");
              ChattingController.to.chats.add(Chat.fromJson(data));
              ChattingController.to.lastChatDate = data['createdAt'];
              ChattingController.to.lastChatUserEmail = data['userEmail'];
            }
          }
        }
        // 채팅 데이터가 비어있지 않으면 첫번째 채팅에 대한 날짜정보와 유저정보 업데이트
        if (ChattingController.to.chats.isNotEmpty) {
          ChattingController.to.firstChatUserEmail =
              ChattingController.to.chats.first.userEmail;
          ChattingController.to.firstChatDate =
              ChattingController.to.chats.first.createdAt;
        }
        // 채팅 데이터가 비어있으면 타임 박스 추가
        else {
          // ChattingController.to.chats.add(Chat(
          //   id: 0,
          //   roomId: roomId,
          //   createdAt: DateTime.now().toString(),
          //   content: "timeBox",
          //   readCount: 0,
          //   type: 'time',
          // ));
          ChattingController.to.firstChatDate =
              DateTime.now().toString(); // 오늘 날짜
          print("firstChatDate 설정 : ${ChattingController.to.firstChatDate}");
        }
      }
      // 채팅 개수 적으면 위쪽에 최근 채팅 날짜 띄우기
      if (ChattingController.to.chats.isNotEmpty &&
          ChattingController.to.chats.length < 20) {
        ChattingController.to.chats.add(Chat(
          id: 0,
          roomId: roomId,
          createdAt: ChattingController.to.lastChatDate!,
          content: "timeBox",
          readCount: 0,
          type: 'time',
        ));
      }
    }
    ChattingController.to.isChatLoading.value = false;
  }

  /// bigCategory 가져오기
  static Future<void> getBigCategories() async {
    final url = Uri.parse('$baseUrl/$events/get-big/');

    var response = await UserDataController.sendHttpRequestWithTokenManagement(
        method: 'get', url: url);

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      ChattingController.to.bigCategories = jsonData['categories']
          .map((data) => BigCategory.fromJson(data))
          .toList();
    }
  }

  /// smallCategory 가져오기
  static Future<void> getSmallCategories({
    required String bigCategoryName,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-small/$bigCategoryName');

    var response = await UserDataController.sendHttpRequestWithTokenManagement(
        method: 'get', url: url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      ChattingController.to.smallCategories = jsonData['categories']
          .map((data) => SmallCategory.fromJson(data))
          .toList();
    }
  }

  /// 퀴즈 정보 불러오기
  static Future<void> getQuizInfo({
    required String quizId,
  }) async {
    final url = Uri.parse('$baseUrl/$events/get-event-page/$quizId');

    var response = await UserDataController.sendHttpRequestWithTokenManagement(
        method: 'get', url: url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      ChattingController.to.eventData.value = Event.fromJson(jsonData['event']);
    }
  }
}
