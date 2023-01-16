# flutter_webtoon

#nomad
nomad 강의 따라 만든 기본 웹툰 어플

#favovrite_page.v1
좋아요 표시한 웹툰만 모아볼 수 있는 favorite_page를 추가한 v1.
- 문제점. 
homepage 즉, ApiServiece().getTodaysToons에서 가져온 thumb과 favor_page, getToonsById에서 가져온 thumb 이미지가 달라서 이상한 회색 padding이 들어간 thumb이 나옴.
이유. getTodaysToons에서는 baseUrl/today 에서 정보를 가져오고 getToonsById는 baseUrl/:id나 baseUrl/today/:id에서 가져오는데 두 곳에 저장된 id는 같으나 thumb파일이 다름을 확인.
-> id를 저장할때 thumb도 같이 저장하거나 파일 구조를 바꿔야 할듯 하다.

