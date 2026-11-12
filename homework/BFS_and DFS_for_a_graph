import java.util.LinkedList;
import java.util.Queue;
import java.util.ArrayList;

int numVertices = 5;
PVector[] vertices = new PVector[numVertices];

// 간선 순서쌍 (Ordered pairs of vertices)
int[][] edges = {
  {0, 1}, {0, 2},
  {1, 0}, {1, 2},
  {2, 0}, {2, 1}, {2, 3}, {2, 4},
  {3, 2},
  {4, 2}
};

// BFS 상태 관리를 위한 변수들
ArrayList<Integer>[] adj; // 인접 리스트
Queue<Integer> queue;
int[] state; // 0: 미방문(회색), 1: 큐 대기중(노란색), 2: 현재 탐색중(주황색), 3: 방문 완료(파란색)
ArrayList<int[]> treeEdges; // BFS 탐색 트리에 포함된 간선들

int currentNode = -1;
int stepDelay = 40; // 애니메이션 속도 조절 (프레임 단위, 클수록 느림)
int first = 0;
int second = 1;

void setup() {
  size(600, 600);
  
  // 1. 정점 원형 배치
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  float radius = 200;
  
  for (int i = 0; i < vertices.length; i++) {
    float angle = map(i, 0, vertices.length, 0, TWO_PI) - HALF_PI;
    vertices[i] = new PVector(centerX + cos(angle) * radius, centerY + sin(angle) * radius);
  }
  
  // 2. 순서쌍 간선 배열을 이용해 인접 리스트 생성 (무방향 그래프)
  adj = new ArrayList[vertices.length];
  for (int i = 0; i < vertices.length; i++) {
    adj[i] = new ArrayList<Integer>();
  }
  for (int[] edge : edges) {
    int u = edge[first];
    int v = edge[second];
    adj[u].add(v);
    adj[v].add(u); // 무방향이므로 양쪽 모두 추가
  }
  
  // 0번 노드에서 BFS 시작
  startBFS(0);
}

// BFS 초기화 및 시작 함수
void startBFS(int startNode) {
  queue = new LinkedList<Integer>();
  state = new int[vertices.length];
  treeEdges = new ArrayList<int[]>();
  currentNode = -1;
  
  state[startNode] = 1; // 큐에 삽입 상태로 변경
  queue.add(startNode);
}

// BFS 한 단계 진행 함수
void stepBFS() {
  // 이전 단계에서 탐색 중이던 노드를 '방문 완료' 상태로 변경
  if (currentNode != -1) {
    state[currentNode] = 3;
  }
  
  // 큐가 비어있지 않으면 다음 노드를 꺼내 탐색
  if (!queue.isEmpty()) {
    currentNode = queue.poll();
    state[currentNode] = 2; // 현재 탐색 중
    
    // 인접한 노드 확인
    for (int neighbor : adj[currentNode]) {
      if (state[neighbor] == 0) { // 미방문 노드라면
        state[neighbor] = 1;      // 큐 대기 상태로 변경
        queue.add(neighbor);
        treeEdges.add(new int[]{currentNode, neighbor}); // 탐색 경로 기록
      }
    }
  } else {
    currentNode = -1; // 탐색 종료
  }
}

void draw() {
  background(245);
  
  // 일정 프레임마다 BFS 한 단계씩 실행
  if (frameCount % stepDelay == 0) {
    stepBFS();
  }
  
  // 1. 기본 간선 그리기 (연한 회색)
  stroke(200);
  strokeWeight(2);
  for (int[] edge : edges) {
    PVector p1 = vertices[edge[first]];
    PVector p2 = vertices[edge[second]];
    line(p1.x, p1.y, p2.x, p2.y);
  }
  
  // 2. BFS로 실제 탐색한 경로(간선) 강조하기 (파란색 굵은 선)
  stroke(70, 130, 180);
  strokeWeight(4);
  for (int[] edge : treeEdges) {
    PVector p1 = vertices[edge[first]];
    PVector p2 = vertices[edge[second]];
    line(p1.x, p1.y, p2.x, p2.y);
  }
  
  // 3. 정점(Vertices) 그리기 (상태별 색상 구분)
  textAlign(CENTER, CENTER);
  textSize(14);
  
  for (int i = 0; i < vertices.length; i++) {
    if (state[i] == 0) fill(180);             // 미방문: 회색
    else if (state[i] == 1) fill(255, 200, 0); // 큐 대기중: 노란색
    else if (state[i] == 2) fill(255, 90, 50); // 현재 탐색중: 주황색
    else if (state[i] == 3) fill(70, 130, 180);// 방문 완료: 파란색
    
    stroke(255);
    strokeWeight(2);
    ellipse(vertices[i].x, vertices[i].y, 38, 38);
    
    // 노드 번호 텍스트
    fill(state[i] == 1 ? 0 : 255); // 노란색 원 위에는 검은 글씨
    text(i, vertices[i].x, vertices[i].y);
  }
  
  // 4. 화면 상단 안내 및 범례 표시
  drawUI();
}

void drawUI() {
  fill(50);
  textAlign(LEFT, TOP);
  textSize(13);
  text("Click any node to restart BFS from that node | Press SPACE to reset", 20, 20);
  text("Queue: " + queue.toString(), 20, 42);
  
  // 색상 범례
  String[] labels = {"Unvisited", "In Queue", "Visiting", "Visited"};
  color[] colors = {color(180), color(255, 200, 0), color(255, 90, 50), color(70, 130, 180)};
  
  for (int i = 0; i < labels.length; i++) {
    fill(colors[i]);
    noStroke();
    ellipse(28 + i * 110, height - 25, 14, 14);
    fill(50);
    text(labels[i], 40 + i * 110, height - 33);
  }
}

// 마우스로 노드를 클릭하면 해당 노드부터 BFS 다시 시작
void mousePressed() {
  for (int i = 0; i < vertices.length; i++) {
    if (dist(mouseX, mouseY, vertices[i].x, vertices[i].y) < 20) {
      startBFS(i);
      break;
    }
  }
}

// 스페이스바를 누르면 0번 노드부터 재시작
void keyPressed() {
  if (key == ' ') {
    startBFS(0);
  }
}
