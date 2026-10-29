String inputText = "";      // 사용자가 현재 입력 중인 텍스트
String expressionText = ""; // Enter를 눌러 최종 확정된 수식
String resultText = "";     // 계산 결과 메시지
boolean isError = false;    // 에러 발생 여부

void setup() {
  size(600, 400);
  textFont(createFont("SansSerif", 20));
}

void draw() {
  background(240);

  // 1. 제목 안내
  fill(50);
  textSize(22);
  textAlign(LEFT, TOP);
  text("Processing 수식 계산기", 40, 40);

  // 2. 입력 상자 그리기
  stroke(180);
  strokeWeight(2);
  fill(255);
  rect(40, 90, 520, 50, 8);

  // 입력 중인 텍스트 표시
  fill(0);
  textSize(22);
  textAlign(LEFT, CENTER);
  text(inputText + (frameCount % 60 < 30 ? "|" : ""), 55, 115); // 커서 바 blink 효과

  // 3. 안내 문구
  fill(120);
  textSize(14);
  textAlign(LEFT, TOP);
  text("수식을 입력하고 Enter 키를 누르세요. (예: 3 + 5 * (2 - 8) / 4)", 40, 155);

  // 4. 결과 출력 영역
  stroke(210);
  fill(250);
  rect(40, 200, 520, 140, 8);

  if (!expressionText.equals("")) {
    // 입력한 수식 표시
    fill(100);
    textSize(16);
    textAlign(LEFT, TOP);
    text("입력 수식: " + expressionText, 60, 220);

    // 계산 결과 표시
    if (isError) {
      fill(220, 50, 50); // 에러 시 빨간색
    } else {
      fill(30, 130, 60); // 성공 시 초록색
    }
    textSize(24);
    text(resultText, 60, 260);
  }
}

// 키보드 입력 처리
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    if (inputText.trim().length() > 0) {
      expressionText = inputText;
      try {
        double result = evaluateExpression(inputText);
        // 정수 형태로 깔끔하게 떨어지면 정수로 출력, 아니면 소수점 유지
        if (result == (long) result) {
          resultText = "계산 결과: " + String.format("%d", (long) result);
        } else {
          resultText = "계산 결과: " + String.format("%.4f", result);
        }
        isError = false;
      } catch (Exception e) {
        resultText = "오류: " + e.getMessage();
        isError = true;
      }
    }
  } else if (key == BACKSPACE) {
    if (inputText.length() > 0) {
      inputText = inputText.substring(0, inputText.length() - 1);
    }
  } else if (key != CODED) {
    // 허용된 키(숫자, 사칙연산 기호, 괄호, 점, 공백)만 입력 받음
    if ("0123456789+-*/(). ".indexOf(key) != -1) {
      inputText += key;
    }
  }
}

// =========================================================
// 재귀 하강 파서 (Recursive Descent Parser)
// 문자열 수식을 직접 해석하여 계산하는 알고리즘
// =========================================================
double evaluateExpression(String str) {
  return new Object() {
    int pos = -1, ch;

    void nextChar() {
      ch = (++pos < str.length()) ? str.charAt(pos) : -1;
    }

    boolean eat(int charToEat) {
      while (ch == ' ') nextChar();
      if (ch == charToEat) {
        nextChar();
        return true;
      }
      return false;
    }

    double parse() {
      nextChar();
      double x = parseExpression();
      if (pos < str.length()) throw new RuntimeException("잘못된 기호: " + (char)ch);
      return x;
    }

    // 덧셈, 뺄셈 처리
    double parseExpression() {
      double x = parseTerm();
      for (;;) {
        if      (eat('+')) x += parseTerm(); // 덧셈
        else if (eat('-')) x -= parseTerm(); // 뺄셈
        else return x;
      }
    }

    // 곱셈, 나눗셈 처리
    double parseTerm() {
      double x = parseFactor();
      for (;;) {
        if      (eat('*')) x *= parseFactor(); // 곱셈
        else if (eat('/')) {                   // 나눗셈
          double divisor = parseFactor();
          if (divisor == 0) throw new RuntimeException("0으로 나눌 수 없습니다.");
          x /= divisor;
        }
        else return x;
      }
    }

    // 숫자, 괄호, 단항 연산자(+, -) 처리
    double parseFactor() {
      if (eat('+')) return +parseFactor(); // 단항 +
      if (eat('-')) return -parseFactor(); // 단항 -

      double x;
      int startPos = this.pos;
      if (eat('(')) { // 괄호 처리
        x = parseExpression();
        if (!eat(')')) throw new RuntimeException("괄호 ')'가 누락되었습니다.");
      } else if ((ch >= '0' && ch <= '9') || ch == '.') { // 숫자 및 소수점 처리
        while ((ch >= '0' && ch <= '9') || ch == '.') nextChar();
        x = Double.parseDouble(str.substring(startPos, this.pos));
      } else {
        throw new RuntimeException("올바르지 않은 수식입니다.");
      }

      return x;
    }
  }.parse();
}
