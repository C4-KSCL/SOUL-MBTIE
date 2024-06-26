import 'package:intl/intl.dart';

// 시간을 "방금/1분전/2시간전/3일전/4주전/2024-12-12"로 바꿔줌
String convertHowMuchTimeAge({required String utcTimeString}) {
  // UTC 시간대를 명확히 하여 DateTime 객체를 생성
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  // 현재 날짜와 시간 (한국 시간 기준)
  DateTime now = DateTime.now().toUtc().add(Duration(hours: 9));

  // 차이 계산
  Duration difference = now.difference(utcTime);
  if (difference.inMinutes < 1) {
    return '방금';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}시간 전';
  } else if (difference.inDays < 7) {
    return '${difference.inDays}일 전';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks주 전';
  } else {
    return DateFormat('yyyy-MM-dd').format(utcTime);
  }
}

// 시간을 "오전/오후 12:12" 으로 바꿔줌
String convertHourAndMinuteTime({required String utcTimeString}) {
  // UTC 시간을 DateTime 객체로 파싱
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  // DateFormat을 사용하여 "오후 12:33" 형식으로 변환
  String formattedTime = DateFormat('a hh:mm', 'ko_KR').format(utcTime);

  formattedTime = formattedTime.replaceFirst('AM', '오전').replaceFirst('PM', '오후');

  return formattedTime;
}

String convertKoreaTime({required String utcTimeString}) {
  // UTC 시간대를 명확히 하여 DateTime 객체를 생성
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();

  String formattedTime = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(utcTime);

  return formattedTime;
}

/// 날짜(년, 월, 일)만 추출하는 함수
DateTime extractDateOnly(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

/// 년, 월, 일, 시, 분 추출하는 함수
DateTime extractDateTime(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
}

/// 년, 월, 일에 대해 문자열로 반환하는 함수
String formatIsoDateString(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  // '2024년 4월 29일' 형식으로 포맷
  return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일';
}