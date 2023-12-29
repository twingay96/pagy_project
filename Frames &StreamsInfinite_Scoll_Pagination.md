    rails g scaffold Artists name

실행 후 faker 데이터 생성:

  ![image](https://github.com/twingay96/pagy_project/assets/64403357/d2391151-5eee-4f2b-bfd7-3ec9e42a0e6a)

    rails db:migrate rails db:seed 

스크롤로 페이지네이션을 구현할때 도움이 되는 메서드 "pagy_countless":
참조 : https://ddnexus.github.io/pagy/docs/extras/countless/

![image](https://github.com/twingay96/pagy_project/assets/64403357/8687ef22-6f78-4bc7-b3ed-06c43e6563b2)


![image](https://github.com/twingay96/pagy_project/assets/64403357/c233aa52-d3b5-43f6-8725-49862f0231f6)


![image](https://github.com/twingay96/pagy_project/assets/64403357/23ed7308-a1d5-4f34-8f68-95f4a3f0540f)

agy_countless는 Ruby on Rails의 페이징 라이브러리인 Pagy에서 제공하는 메서드 중 하나입니다. 
이 메서드는 "countless" pagination을 지원합니다. 전통적인 페이징에서는 각 페이지를 표시하기 전에 전체 컬렉션의 크기(예: 데이터베이스 테이블의 전체 행 수)
를 알아내기 위해 COUNT 쿼리를 실행합니다. 이는 때때로 성능에 부담을 줄 수 있습니다, 특히 매우 큰 데이터셋을 다룰 때 그렇습니다.

pagy_countless 메서드는 이런 COUNT 쿼리를 실행하지 않고 페이징을 처리합니다. 
대신에 다음 페이지의 존재 여부만을 체크하여, 사용자가 마지막 페이지에 도달했는지를 확인합니다. 
이 방식은 큰 데이터셋에서 성능을 향상시킬 수 있지만, 전체 페이지 수나 마지막 페이지가 몇 번째인지를 알 수 없다는 단점이 있습니다.

이러한 접근 방식은 서버의 부하를 줄이고, 더 빠른 사용자 경험을 제공하는 데 유용할 수 있지만, 
사용자가 전체 페이지 수를 알아야 하는 경우나 페이지네이션의 특정 페이지로 직접 접근해야 하는 경우에는 적합하지 않을 수 있습니다.

