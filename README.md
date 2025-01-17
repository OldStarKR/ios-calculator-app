## iOS 커리어 스타터 캠프 4. 계산기

### CalculatorItemQueue와 내부에 들어갈 Linked List의 관계를 나타낸 UML
![계산기 큐와 리스트](https://user-images.githubusercontent.com/102375432/168695203-b154fc18-385b-4dfb-894a-01314dc6782d.png)

---
## STEP 1

### STEP 1 작업한 내용
* TDD 방법론에 기반하여 작업
* `Queue` 프로토콜 정의
* `CalculatorItemQueue` 구현
    * `Queue` 프로토콜에 부합하며, 배열을 활용해 구현
    * 내부에 들어가는 원소들은 `CalculateItem` 프로토콜에 부합

---

### STEP 1 고민한 점
* TDD 방법론을 자료구조 구현 시의 타입 메서드 작성 시에도 적용하는 것이 맞을까?
* 처음에 테스트 코드를 짰을 때는 큐에 `Int`가 들어간다고 전제하고 짰지만, 이후 `CalculateItem`에 conform하게 만듬으로써 테스트 코드가 빌드가 되지 않았다. 이를 해결하기 위해 `CalculateItemTester`라는 임시 타입을 만들어서 테스트를 진행했는데, 이렇게 해도 괜찮을까?
* `enqueue` 메서드를 테스트할 때, 큐 내부의 배열을 들여다볼 방법이 없으므로 이미 검증된 후의 `dequeue` 메서드를 활용해서 테스트했다. 그러나 각각의 테스트 케이스는 독립적이어야 한다고 알고 있는데, 이 경우 어떻게 테스트를 진행하면 좋을까?

---

### Step 1 질문에 대한 피드백
- TDD의 과정을 지금은 모두 커밋해 주었지만, 충분히 연습이 되고 나면 Red - Green - Refactor 단계를 하나의 커밋으로 작성해도 된다.
- Test Double의 성격으로, 큐의 테스트만을 위해 새로운 자료구조를 정의하는 것은 옳은 흐름! 다만, Unit Test 안에 위치시킬 필요는 있어 보인다.
- 테스트가 독립적이어야 한다는 것이 꼭 하나의 메서드를 써야만 한다는 것이 아니다. 이미 앞에서 검증된 메서드를 쓰는 것은 가능. 오히려 이걸 테스트하려고 private을 깨는 것이 더 지양되어야 할 흐름!
- 커밋 로그가 좀 더 정리되면 좋을 듯.. 단순 개행 같은 것은 작업할 때 남길 수는 있다. 하지만 PR 하기 전에 interactive rebase 활용해서 정리해주는 것이 괜찮을 것.

---
## STEP 2

### STEP 2 작업한 내용
* 사칙연산을 나타내는 `Operator` 타입을 구현
* 사용자가 입력한 식을 나타내는 `Formula` 타입을 구현
* 사용자의 입력을 받아서 `Formula`로 바꿔 주는 `ExpressionParser` 네임스페이스를 구현

---

### STEP 2 고민한 점
* 기능 요구서에 주어진 UML의 해석이 전반적으로 어려웠다. 아직 UML에 대한 숙련도가 떨어질 뿐더러, 제 자신이 생각하고 짠 것이 아니기 때문에 주어진 요구사항을 어떻게 구현해야 할지에 대해 많이 고민했다.
* `ExpressionParser` 안의 `componentsByOperators`가 무슨 뜻인지 알아듣지 못해 처음에 어려움을 겪었다. 일단 연산자만 반환하는 거라고 받아들여서, 연산자만 반환했다.
    * 원래는 result 배열을 따로 만들고 연산자의 `allCases`에 대해 `forEach` 클로저 안에서 `result` 배열 안에 들어있는 개개의 케이스마다 연산자를 기준으로 분리해주고 flatten해주는 과정을 반복해서, 숫자와 연산자가 예쁘게 떨어져 있는 배열을 반환하고자 했으나, 클로저 안에서 `compactMap`을 불러올 수가 없었어서, 현재의 방향으로 선회
    * 또한 해당 배열을 만들 수 있다 해도, 연산자를 판별할 수 있는 `isNumber`는 `Character`를 대상으로 하는 메서드라, 두 자리 이상의 수를 반환할 수 없다는 문제도 있었다. 이래저래 연산자만 반환하는 것이 맞다고 받아들였지만..
* 0으로 나눌 때, 큐에 더 이상 아이템이 없을 때 등 에러 핸들링을 해야 할 몇 가지 상황에 todo 주석을 달아 두었는데, 이는 함부로 뭘 추가하지 말라는 기능 요구서에서의 요구사항 때문. 물론 에러 케이스를 분리하는 것은 좋다고 써 있지만, 그와는 별개로 새로운 타입의 지정이기 때문에, 이 문제를 저 자신이 인지하고 있는 상태에서 리뷰어와 대화를 나눠 보고 싶었다. 
    * 기본값을 0으로 지정한 이유는, 계산기라는 프로그램에서 기본값은 0으로 여겨지기 때문입니다. 다만 이 경우, 의도치 않게 0으로 나누는 문제가 발생할 수도 있어, 주시 중
* 케이스가 하나도 없는 `enum` 안에 메서드를 써 넣는다는 것은, `enum`을 온전히 네임스페이스로 쓴다는 것임을 알았다. 따라서 `static`을 붙여야 한다는 것.
* 개인적으로 시간에 쫓길 일이 있어서, 완전히 TDD를 적용하지 못 한 것이 아쉬움

---

### STEP 2 조언을 얻고 싶은 점
* 기능요구서의 UML에 작성되어 있는 `split`함수의 구현 요구사항에 대한 이유
    * 기존 `split`은 `String`을 반환하지 않으니까, 라고 하면 이해는 가지만, 그리고 요구서에 써 있는 대로 구현했지만, 구현한 것을 당장은 사용하지 않음. `ExpressionParser` 안에서 사용한 `split`은 [여기](https://developer.apple.com/documentation/swift/string/2893447-split) 나온 `split`.
    * `Operator`가 `CaseIterable`인 이유, `split`을 구현하게 한 이유, `componentsByOperators`가 `[String]`을 반환하는 이유 모두 연계되어 있다고 생각해서 그쪽 방향으로 짜 보려고 했지만, 아쉽게도 세 가지 간의 얼개를 분명하게 찾을 수가 없었음.
* `parse` 메서드 안에서, 타입 캐스팅을 하는 과정에서는 어쩔 수 없이 옵셔널이 발생한다. 이 경우 `if let`을 통해 옵셔널을 해제해 주었는데, 이렇게 하는 것이 이 상황에서 맞는지, nil-coalescing operator를 통해서 기본값을 주는게 더 나았을지,
    * 일단 `operators`와 `operands`는 이미 작성한 로직을 통해 내부의 값을 보장할 수 있으므로 값이 들어가지 않을 일은 없다고 생각했지만, 절대라는 건 없다고 생각하니만큼, 기본값의 제공을 통해 일단 동작하게는 했어야 했을지.
    * 다만 기본값을 제공한다면, 비슷한 오류가 발생했을 때 사용자가 의도치 않은 값을 받아들게 되고, 그것은 잘못된 동작이라는 면에서 결국 대동소이하다는 생각이 들었다.

---

### STEP 2 질문에 대한 답변 및 피드백
- ExpressionParser, Formula에 대한 테스트 코드도 작성해야 할 것 같다.
- componentsByOperators는 operator를 기준으로 나뉘어진 값을 반환하는 메서드라고 본다.
- 에러 타입은 명세와 별도로 정의해도 괜찮다고 생각한다.
- TDD는 지속적으로 연습해야 되니까, 너무 조급하게 생각하지 않아도 괜찮다.
- split을 구현하라 한 이유는, parse → componentsByOperators → split의 흐름이 아닐까 싶다.
- 타입 캐스팅 과정에서 while let을 써서 옵셔널을 컨트롤해보는 것은 어떨지??

---
## STEP 3

### 최종 UML

![계산기 UML](https://user-images.githubusercontent.com/102375432/170816599-891166b2-9790-4f81-a3a9-92f8a9d78671.png)


### STEP 3 작업한 내용
* `CalculatorViewController`를 통해 UI와 이전에 만들어 두었던 로직을 연계
    * 숫자, 소수점 버튼을 누르면 숫자와 소수점이 입력
    * 연산자 버튼을 누르면, 숫자가 0일 경우 연산자만 바뀌게 했고, 그렇지 않을 경우 지금까지 입력해 둔 숫자와 연산자를 저장하고 새로이 0을 가져와서 계산
    * AC 버튼을 누르면 지금까지의 모든 연산 입력이 초기화
    * CE 버튼을 누르면 현재의 연산 입력이 초기화되게 했으나, 계산이 모두 끝난 뒤에 누르면 전체적으로 초기화
    * 부호 버튼을 누르면 현재 계산하고 있는 수의 부호 전환
    * 0으로 나누었을 경우, NaN이 뜨면서 AC와 CE 이외의 기능이 작동하지 않음
* UI 상단의 사용자 입력을 관리하기 위해, Stack View를 추가하는 방식을 사용
    * `IndividualInputStackView` 클래스를 정의해, 저장해야 할 값이 생길 때마다 해당 클래스를 불러 와 초기화하고 메인 스크롤 뷰 안의 스택 뷰에 추가

연산자 버튼, 등호 버튼, AC 버튼 작동 예시

![연산자와_등호_AC_AdobeCreativeCloudExpress](https://user-images.githubusercontent.com/102375432/170815545-f8a59b7e-659d-4f48-9944-679ace03226e.gif)

CE 버튼, 연산자 바꾸기 작동 예시

![CE와_중간에_연산자바꾸기_AdobeCreativeCloudExpress](https://user-images.githubusercontent.com/102375432/170815546-ac2b5fd5-4e84-4b21-9895-f9f1915dd2f8.gif)

부호 바꾸기 버튼 작동 예시

![부호바꾸기_AdobeCreativeCloudExpress](https://user-images.githubusercontent.com/102375432/170815548-24434e92-d209-41df-956a-fafc9c5e63fd.gif)

소수점 버튼과 0 버튼 작동, 숫자 포매팅 예시

![소수점버튼과_0버튼_숫자포매팅](https://user-images.githubusercontent.com/102375432/170815556-b6d9c856-9f16-4784-b46c-6a2925abb094.gif)

0으로 나누었을 때 NaN 반환 예시

![NaN](https://user-images.githubusercontent.com/102375432/170815561-5abef592-15e6-48f7-a941-eabdd8838c95.gif)

계산 결과가 길어질 때 자동 스크롤 예시 - 미완성

![자동스크롤_미완성_AdobeCreativeCloudExpress](https://user-images.githubusercontent.com/102375432/170815564-64b19489-0dc9-4dfb-9cb4-9ba8f3622998.gif)

---

### STEP 3 고민한 점
* 이미 정의한 `split` 메서드를 어떻게 활용해야 마이너스 수까지 다룰 수 있을지?
    * 부호 바꾸기 버튼이 있기 때문에 일어난 현상
    * - 기호를 기준으로 `split`해버리면, 빼기일 때와 마이너스일 때를 구분하지 못하기 때문
    * 그러나, 빼기 기호에도 비슷하게 생긴 다른 것이 있었다. 그냥 -키를 눌렀을 때 입력되는 문자와, option키를 누르고 -키를 눌렀을 때 입력되는 문자의 유니코드가 달랐다.
    * 다만, 혼동하기 쉬운 문자라 네임스페이스를 통해 관리해주고 싶었으나, 같은 문자에 대해 String으로 쓰는 부분이 있고 Character로 쓰는 부분이 있어서, 또 Operator enum의 rawValue는 다른 곳에서 불러오는 것이 아닌, 정해진 값을 써야 해서 불발
* 스크롤 뷰의 목업 스택 뷰를 지웠을 때, 스크롤 뷰의 높이가 Ambiguous하다는 경고가 표시
    * 우선도가 더 낮은 Constraint를 추가로 부여함으로써 최소한의 높이를 설정
* 지금 프로젝트처럼 스크롤 뷰 안에 스택 뷰를 사용하기보다, 스크롤 뷰 안에 테이블 뷰를 넣고 커스텀 셀을 통해 계산 결과를 채워 주는 것은 어떨까 고민
* UI 테스트를 시도하는 과정에서의 어려움. 뷰 컨트롤러 안의 여러 메서드는 사실 눈으로 보여지는 것에 의미가 있기 때문에, 테스트 코드를 어떻게 작성해야 할지 막막해서 일단은 작성하지 않은 상태
* 스크롤 뷰를 자동으로 맨 밑까지 내려야 할 때, 꼭 한 칸 정도씩 덜 내려가는 현상이 발생. 당장은 내려갈 수 있다는 것에 의의를 두고 있지만, 스크롤 뷰의 속성 중 contentSize와 bound에 대해 공부해야 할 것으로 보임.
