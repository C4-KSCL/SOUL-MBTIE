/// 문자열의 문자 개수가 10개가 넘어가면 자르고 뒤에 ... 붙이기
String summarizeText(String content) {
  if (content.length > 14) {
    return "${content.substring(0, 14)} ...";
  }
  return content;
}

String splitAndJoinText(String text) {
  return text.replaceAll(' vs ', '\nvs\n');
}