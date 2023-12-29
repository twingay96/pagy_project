    rails g scaffold comments body:text
    rails g db:migrate

참조 : https://github.com/kevquirk/simple.css/wiki/Getting-Started-With-Simple.css

실행후 생성된 views/layouts/application.html.erb에 <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css"> 추가하여 simpleCSS적용 및 root 설정:
![image](https://github.com/twingay96/pagy_project/assets/64403357/1b5f815a-d46c-459f-9a9e-ea80957f3113)
![image](https://github.com/twingay96/pagy_project/assets/64403357/2230b3cb-8e61-40f8-b998-2057e9c469c4)

설정후 rails s실행하여 확인 :

![image](https://github.com/twingay96/pagy_project/assets/64403357/ff919420-7a7c-4f26-bff0-76128c0e2312)



테스트용 다량의 데이터를 입력하기 위해 faker gem을 사용, gem 'faker'추가후 bundle install (bundle add faker로하면 이상하게 에러가 발생하므로 직접추가)

참조 :https://github.com/faker-ruby/faker

실행후에 seeds.rb에 다음과 같이 입력후 "rails db:seed" 명령어 실행:

![image](https://github.com/twingay96/pagy_project/assets/64403357/7ea9ae11-571c-4bc0-b317-1a57acc1a7c9)

rails c 및 rails s실행 하여 생성된 데이터들 확인:

![image](https://github.com/twingay96/pagy_project/assets/64403357/7d7cf149-3789-4d18-b741-7f31e2a0d4b7)
![image](https://github.com/twingay96/pagy_project/assets/64403357/daa6a340-3ca0-41f0-ac3f-516624562c21)

Pagy는 Ruby on Rails에서 사용할 수 있는 고성능 페이징 라이브러리로, 컬렉션에 대한 페이징 처리를 수행할 때 사용
페이지네이션 기능을 구현하기 위해 pagy gem을 사용, gem 'pagy' 추가후 bundle install 실행

참조 :https://github.com/ddnexus/pagy

실행 후, controllers/application_controller.rb에 다음 과같이 코드추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/c3cdae98-407d-43ce-bf0d-7e9b7729e0e4)

Pagy::Backend 모듈을 ApplicationController에 포함시키면, 이 모듈에 정의된 메서드들이 ApplicationController와 그 자식 컨트롤러에서 사용 가능해집니다.

![image](https://github.com/twingay96/pagy_project/assets/64403357/9b4ab5e4-fe1b-43c6-bf2d-ce5310f8e87c)

Pagy::Frontend 모듈은 페이징을 위한 뷰 관련 메서드를 제공합니다. 이러한 메서드를 통해 개발자는 레코드의 페이지네이션에 대한 사용자 인터페이스를 쉽게 만들 수 있습니다.

예를 들어, 뷰에서는 pagy_nav 메서드를 사용하여 페이지네이션 바를 생성할 수 있습니다:

![image](https://github.com/twingay96/pagy_project/assets/64403357/b3ad916f-aea6-4e24-b965-4aadee6e5af1)

이제 index액션 및 index뷰에 페이지네이션 기능을 추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/0001a7fe-2eb8-4aad-a6dc-3e953e63f91d)

![image](https://github.com/twingay96/pagy_project/assets/64403357/953c99c9-7d4d-42fb-b4a5-b90945f6cde9)

rails s실행하여 실제 페이지네이션 적용 되었는지 확인:

![image](https://github.com/twingay96/pagy_project/assets/64403357/2af85f04-7c6f-4fa5-b73f-93e06c3d1f1d)

한페이지당 5개의 item이 출력되고 페이지네이션구현된걸 확인할 수 있음

여기서 next page link를 구현해야하기 때문에 다음 과 같이 수정:

참조 :https://ddnexus.github.io/pagy/docs/extras/support/

![image](https://github.com/twingay96/pagy_project/assets/64403357/c18e53e3-dc5f-4655-ba8b-2220a17a57dc)

config/initializers에 pagy.rb생성 후 require 'pagy/extras/support'추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/d69a1ffc-11f7-4dba-8228-776b6c6d9342)
![image](https://github.com/twingay96/pagy_project/assets/64403357/c56fad18-dac3-49fd-8ef5-617b8473baa6)

후에 뷰에서 다음과 같은 헬퍼를 사용가능함:
![image](https://github.com/twingay96/pagy_project/assets/64403357/8b847432-7e03-4846-9d40-32cb134461e8)
![image](https://github.com/twingay96/pagy_project/assets/64403357/669e5556-5567-472c-b49b-dfbb46b868d0)
![image](https://github.com/twingay96/pagy_project/assets/64403357/404ac3e7-0b81-464a-9186-b850aaa651c2)

여기에 turbo_stream으로 페이지네이션을 구현하기위해서 index 액션에 post요청을 보내는 link와 이를 처리하는 route가 필요함:

route추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/8b1c14a8-bad4-4c16-a924-5a56df044d7d)
![image](https://github.com/twingay96/pagy_project/assets/64403357/4391727c-c6e6-4d18-b1fc-2794b3bac4dd)

index 액션에 turbo_stream 응답추가:
![image](https://github.com/twingay96/pagy_project/assets/64403357/921631ee-60fc-4c65-a28f-a9b1b01d0332)

그리고 index.html.erb에 turbo_stream요청을 하는 페이지네이션 버튼을 추가:

참조 :https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/support.rb

![image](https://github.com/twingay96/pagy_project/assets/64403357/e84e004e-f00b-469e-bd91-e0ec9d64a257)

이제 해당 turbo_stream 요청에 응답할 수 있는 index.turbo_stream.erb 템플릿 생성:
![image](https://github.com/twingay96/pagy_project/assets/64403357/454ebb1c-b61f-4aeb-9539-e775078dcebf)

이때 <%=render @comments %>에 사용되는 @comments은 next page에 대한 collection임
(즉, @commnets 는 index 액션에서 페이지네이션 처리된 후의 댓글 목록)

이렇게하면 root_path인 "http://127.0.0.1:3000/"에서는 turbo_stream이 동작안하는데, "http://127.0.0.1:3000/comments"에서는 정상동작하는 문제가 있음.

하지만 이렇게 구현하면 단 한번만 버튼이 정상동작함 그이유는 버튼에 있는 url이 
append하기전페이지의 다음페이지(방금 추가된페이지)를 가르키기 때문에, 따라서 기존의 버튼을 다다음페이지를 가르키는 url을 
가지도록 turbo_stream.update해줘야함

버튼을 turbo_stream으로 특정할 수 있도록 div id="load_more_button" 추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/07e7c339-01e3-47d0-823a-aa1e1ebdd539)

그 후에 index.turbo_stream.erb에 다음과 같이 index액션에 대해 turbo_stream으로 응답할 요소 추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/e11c7a1d-0540-44b5-8796-f1192506814a)

![image](https://github.com/twingay96/pagy_project/assets/64403357/dec0528c-9e54-452d-a54f-d192dde9405a)

계속 적용이 가능해졌음, 하지만 페이지의 끝에서 load more 버튼을 누르면 무한반복됨.

![image](https://github.com/twingay96/pagy_project/assets/64403357/72cb27b1-089d-477a-a023-d99dd0270db4)


여기서 page의 끝에 다다랐을때 button이 비활성화 되게해야함, 확인을 위해 items 개수수정, _comment.html.erb에 id추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/2ab34a55-a950-4cf9-a3fd-1d1d58caf4fa)

![image](https://github.com/twingay96/pagy_project/assets/64403357/189bce40-40f5-433f-89db-9806904f7820)

그후에, index.turbo_stream.erb에 조건문추가:

![image](https://github.com/twingay96/pagy_project/assets/64403357/fd5bce78-5f8c-4c58-a914-1f0aeb80c9de)

![image](https://github.com/twingay96/pagy_project/assets/64403357/df538d69-9480-4f2e-beb8-4e690cb1fb19)

마지막 페이지에서 버튼이 사라진것을 확이가능.

그리고 현재 상태에서 rails s 실행후 http://127.0.0.1:3000 를 주소창에 입력하여 방문하여 

![image](https://github.com/twingay96/pagy_project/assets/64403357/f8a692e3-a65d-4c2d-ab63-f5e92c22eb72)

Load more 버튼 클릭시 페이지네이션 기능이 동작하지 않는 것을 확인 할 수 있음. 
pagy_url 기능은 현재 방문 중인 url을 기준으로 params[:page]를 전달 하는 메소드이기 때문에 
http://127.0.0.1:3000로 방문한 페이지에서는  pagy_url메소드가 정상동작하지 않음

따라서 index 액션에 다음과 같이 수정:

![image](https://github.com/twingay96/pagy_project/assets/64403357/4346234e-3f3f-4a3a-9778-b73eb619b3bb)

request.path == "/": 이 조건은 현재 요청의 경로가 루트 경로("/")인지를 검사합니다. 
루트 경로는 웹사이트의 가장 기본이 되는 경로를 말하며, 일반적으로 웹사이트의 홈페이지를 가리킵니다.

Rails 컨트롤러에서 request 객체를 사용하면 다음과 같은 여러 가지 정보를 얻을 수 있습니다:

        request.path: 요청된 경로를 문자열로 반환합니다.
        request.fullpath: 쿼리 스트링을 포함한 전체 경로를 반환합니다.
        request.url: 전체 URL을 반환합니다.
        request.method: 요청 메소드 (예: GET, POST, PUT, DELETE 등)를 반환합니다.
        request.query_parameters: URL의 쿼리 스트링 파라미터를 담고 있는 해시를 반환합니다.
        request.request_parameters: POST 요청의 바디를 담고 있는 해시를 반환합니다.
        request.headers: HTTP 요청 헤더를 담고 있는 객체를 반환합니다.
        request.remote_ip: 요청을 보낸 클라이언트의 IP 주소를 반환합니다.
        request.referer 또는 request.referrer: 이전 페이지의 URL을 반환합니다 (HTTP Referer 헤더를 기반으로 함).
        request 객체는 Rack 미들웨어에 의해 생성되며, Rails 애플리케이션에서는 이 객체를 통해 요청에 대한 상세한 정보를 얻을 수 있습니다. 컨트롤러의 액션 내에서 request 객체를 사용하여 요청을 처리하는 로직을 작성할 때, 이 객체의 메서드와 속성을 활용하게 됩니다.








































