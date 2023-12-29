scroll pagination기능(javascript, stimulus없이 구현)을 사용할 post생성:

    rails g scaffold posts title image_url
    rails db:migrate
  
rails s 실행하여서 동작하는지 확인후 , faker gem을 이용해서 test용 데이터를 생성:


![image](https://github.com/twingay96/pagy_project/assets/64403357/75fedc8a-a8f1-4918-a1c2-fd82bcb01a7d)
![image](https://github.com/twingay96/pagy_project/assets/64403357/2591abb6-7852-4514-891e-4ee27260cff9)

db가 변경되었으므로 rails db:reset 으로 데이터베이스를 초기화(?) 에러발생:
![image](https://github.com/twingay96/pagy_project/assets/64403357/8c7dfaf3-a9c6-4ca6-b022-751fbd897572)

rails db:seed 실행하여 데이터베이스에 faker 값들 입력후 확인:

![image](https://github.com/twingay96/pagy_project/assets/64403357/56b3ac22-03dc-47e2-b684-b3659425be8c)

image_url이 정상동작하도록 image_tag로 수정 및 페이지네이션 동작여부 쉽게알기위해서 id추가 :

![image](https://github.com/twingay96/pagy_project/assets/64403357/62a5dc7d-643b-4403-a355-28ef79795d2e)
![image](https://github.com/twingay96/pagy_project/assets/64403357/ffad3fbd-6fb6-4c6a-a93e-60632b6e7a7c)

페이지네이션 페이지수 5개로 컨트롤러에 설정:
![image](https://github.com/twingay96/pagy_project/assets/64403357/eefb3655-3cfb-4a4d-aa5a-3c368846b4ef)

turbo_frame_tag를 통해 현재 화면의 스크롤의 끝이 다다랐을때 next 페이지가 렌더링 되게끔 해야함(modal 구현할때랑 비슷하게):

![image](https://github.com/twingay96/pagy_project/assets/64403357/f456a871-4a13-4ba6-b931-01a51f2c5bad)
![image](https://github.com/twingay96/pagy_project/assets/64403357/f8f9f381-aaa0-405e-87d6-e08f6fc6b184)

화면에 <%= @pagy.next %>가 '2'로출력됨, 즉 다음페이지는 '2' 즉, <%= turbo_frame_tag "posts-page-#{@pagy.next}" %>
가 post 요청을 발생시켜서 페이지 2가 렌더링 되게끔해야함:

        <%= pagy_url_for(@pagy, @pagy.next) %>

pagy_url 헬퍼는 현재 방문중인 url에 페이지 번호와 같은 페이징 관련 파라미터만 변경하여 새로운 url을 생성합니다.

클라이언트가 현재 방문중인 페이지(예: 목록을 보여주는 index 액션)에 대해, 다음 페이지로 이동할때 필요한 url을 생성,
이렇게 생성된 url은 같은 컨트롤러내의 index 액션을 재호출하여 params[:page]파라미터를 사용하여 적절한 페이지의 데이터를 조회하여 반환.

![image](https://github.com/twingay96/pagy_project/assets/64403357/3288519b-8ad4-4465-863d-9af899187b4f)

수정후 /posts?page=2로 방문해보면:
![image](https://github.com/twingay96/pagy_project/assets/64403357/83d29182-af48-4c0a-8b8b-9f929e4671c8)

/posts?page=2 GET메소드만을 요청한다는 것을 확인가능 , loading: :lazy 를추가하고 새로고침 후 맨 아래로 스크롤해보면:
![image](https://github.com/twingay96/pagy_project/assets/64403357/6a7e92f7-3de8-4b0e-9af5-1ef0762603f4)
![image](https://github.com/twingay96/pagy_project/assets/64403357/99930319-5a3c-422a-acfb-3428c80496da)

![image](https://github.com/twingay96/pagy_project/assets/64403357/bb08455f-2453-4ca2-82ed-72f6c058e568)
다음 페이지인 /posts?page=3을 요청한다는 것을 확인 할 수 있음,

이제 <%= turbo_frame_tag "posts-page-#{@pagy.next}", loading: :lazy ,src: pagy_url_for(@pagy, @pagy.next)%>가 
찾을 수 있는 turbo_frame_tag "posts-page-#{@pagy.next}"요소를 추가해야함. 

이때 next 페이지를 요청하는 경우에만 render할 템플릿을 따로 만들어야함:

![image](https://github.com/twingay96/pagy_project/assets/64403357/c5600609-466f-413c-bdfd-c9c8fdf43b63)

pagy_url 헬퍼는 params[:page]파라미터를 사용하여 다음페이지 정보를 컨트롤러측에 넘겨주기에 if params[:page]으로 페이지네이션 동작만 구별가능.

이때 scrollable_list.html.erb는 index.html.erb의 turbo_frame_tag에서 발생한 요청에대한 응답으로 보여줄 페이지임 :

![image](https://github.com/twingay96/pagy_project/assets/64403357/ea2e7131-3c98-4a64-8139-e0c585294382)

인데 이상태에선 한번만 스크롤 페이지네이션이 동작함(기존의 turbo_frame_tag가 여전히 2를 가르키기 때문에)
기존의 <%= turbo_frame_tag "posts-page-#{@pagy.next}", loading: :lazy ,src: pagy_url_for(@pagy, @pagy.next)%>를 _next_page.html.erb로 옮기기:

![image](https://github.com/twingay96/pagy_project/assets/64403357/046072f4-f49c-4a4e-9ca7-990366b884a2)

그 후, scrollable.html.erb 파일 수정:

![image](https://github.com/twingay96/pagy_project/assets/64403357/b3851247-dfc6-4987-8ae7-22172b899512)

그 후, index.html.erb 파일 수정:

![image](https://github.com/twingay96/pagy_project/assets/64403357/6dac3ae1-2809-45fa-904c-a9b0e29e1fe7)

즉, 

![image](https://github.com/twingay96/pagy_project/assets/64403357/34ffb8c8-74c3-4796-840b-1203c1163942)


            1. index.html.erb에서 render "posts/next_page"동작  
            2. next_page.html.erb에서 스크롤이 화면끝에 도달할 경우 turbo_frame_tag 요청발생 (pagy_url_for(@pagy, @pagy.next)) 
            3. posts_controller.rb의 index액션에서 render "scrollable_list"동작  
            4. scrollable_list.html.erb turbo_frame_tag응답하면서 <%= render "posts/next_page"%>을 통해 다시 1로 회귀

꼬리에 꼬리를 무는식으로 동작하는 구조임.

lazy동작중(로딩중)에 다음과 같이 임의로 출력될 뭔가를 지정할 수 있음:

![image](https://github.com/twingay96/pagy_project/assets/64403357/7d9d215a-ac42-44f1-b322-daf62970b47d)

현재 다음과 같이 content missing 에러가 발생하는 중:

![image](https://github.com/twingay96/pagy_project/assets/64403357/66abfc61-f5d1-4bbf-af4f-b7e71b6fb180)























