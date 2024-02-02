# EasyTree : 웹 기반 식물 엽록체 유전자 계통 분석 프로그램

### EasyTree : Web-based Plant Chloroplast Gene Phylogenetic Analysis Program

#### 초록

 

요약: 식물 간의 서열을 비교하기 위해서는 해당 식물의 서열 데이터와 서열을 분석할 도구가 필요하다. 이러한 준비과정들은 생물정보학을 연구함에 있어서 번거로운 작업이다. EasyTree(http://easytree.site/)는 식물의 단백질별로 계통수를 분석할 때의 과정을 간략화하여 사용자의 편리함을 고려하였다. 이를 위해 서버에는 NCBI(https://ncbi.nlm.nih.gov/)에 있는 엽록체 단백질의 아미노산 서열 데이터를 저장했다. 사용자는 서열 분석 도구인 MUSCLE과 jsPhyloSVG가 사용된 계통수의 결과를 웹에서 쉽게 볼 수 있다. 사용자는 서버에 있는 데이터들 중에서 분석하고자 하는 데이터를 선택할 수 있다. 서버에 데이터가 없더라도 사용자의 입력을 통하여 계통수를 분석할 수 있다. 또한 사용자는 3가지의 서열 분석 method를 통해 하나의 분석 세트에 대해 여러 가지 방식으로 계통수를 그려볼 수 있다. 그 결과, 사용자는 한 번에 최대 15개의 단백질 아미노산 서열과 추가로 분석하기를 원하는 아미노산 서열간의 계통수를 볼 수 있고, 그에 따른 Newick Format과 다중시퀀스정렬 결과를 제공받을 수 있다. 결론적으로, 데이터 준비와 분석 tool을 준비하는 것에 대한 사용자의 번거로움을 줄여주는 한글 기반으로 구성된 웹 application을 개발했다.

 

###### 핵심 주제어: EasyTree, 계통수, MUSCLE, 다중시퀀스정렬, Newick Format, 웹 application

 

#### Ⅰ. 서론

 

20세기 분자 생물학의 눈부신 발전으로 베일에 가려져 있던 유전정보들이 다양한 Genome Sequencing Projects를 통해 밝혀지면서 염기서열을 비롯한 많은 생물학 기초 데이터들이 기하급수적으로 증가했다. 따라서 이러한 자료는 목적에 따라 체계적으로 수집, 정리 그리고 가공하는 것이 필요하게 되었다.1)

국내의 경우‘Bioinformatics and Biosystems Journal’에 따르면 광의적인 의미로 생명정보학을 “컴퓨터를 사용하여 생물 정보를 다루는 여러 형태의 접근방식”이라고 정의하고 있으며, 협의적으로는 “DNA, 아미노산 순열 및 그와 연관된 정보를 이용하여 생명현상을 이해하는 것을 목적으로 하는 수학적, 통계학적, 컴퓨터 방법을 사용하는 학문 분야”라고 정의하고 있다.2) 따라서 생명정보학의 학습은 컴퓨터와 생물학이 연합되어있는 Cross training 교육이다.3) 이 뿐만 아니라 생명정보학의 관련된 대부분의 학습자료 및 연구자료에는 한국어로 된 문서들은 매우 적고, 또한 한글로 된 application은 없다. 다시 말해 생명정보학을 처음 접하게 되는 입문자들에게는 어려움이 있는 것이다

이 뿐만이 아니라 생명정보학을 학습하고 연구하기 위한 절차는 (1)분석하고자 하는 종들을 정하고, 각 종들 간에 비교할 상동 유전자를 선정한 후, (2) 상동유전자 서열을 수집하고, (3)종간의 공통 유전자 서열에 대하여 군집화를 수행한다. 마지막으로, (4)군집화된 서열 그룹에 대하여 다중서열정렬을 수행한다. 이러한 일련의 작업에 있어서 서열 데이터와 분석 도구를 준비해야 하는 것은 사용자의 불편함을 야기한다. 또한 사용자의 컴퓨터에서 분석을 수행할 시, 해당 작업은 불필요한 시간과 자원의 낭비를 초래한다.4)

본 논문에서는 생명정보학자 및 생명정보학을 배우기 시작하는 입문자들을 위해 MUSCLE프로그램 기반의 웹 application을 제시한다. 본 웹 서비스의 장점은 다음과 같다. 첫째, NCBI(https://ncbi.nlm.nih.gov/)에서 제공하는 식물 엽록체의 아미노산 서열들을 최대한 담아 사용자가 직접 데이터를 수집해야하는 번거로움을 줄였다. 둘째, 계통수 분석과정을 간략화하여 사용자는 버튼 클릭만으로 모든 과정을 웹 application에서 해결이 가능하다. 셋째, 이 모든 과정이 한글로 구성되어 생명정보학을 처음 접하는 입문자들에게 편리한 학습 환경을 제공할 수 있다. 넷째, 계통수를 분석한 결과를 파일로 다운로드를 받을 수 있어 사용자가 분석결과를 추출하는 것에 대한 번거로움을 줄일 수 있다. 다섯째, 본 웹을 반응형 웹으로 만들어서 모바일에서도 작업을 수행할 수 있다.

생명정보학은 데이터 수집에서부터 분석도구결정, 컴퓨터 활용까지의 작업들이 많으며 관련 대부분의 자료와 application은 외국어로 되어있어서 입문자들이나 연구자들이 학습 및 연구를 수행함에 어려움이 있다. 따라서 사용자의 서열 입력과 분석방식 도구 선택만으로 계통수 결과를 보여주는 편리한 웹 application을 개발하였다. 이 플랫폼은 한국어를 기반으로 만들어졌기 때문에 향후 한국의 생명정보학 및 계통분석의 입문자들에게 학습과 연구의 편리성을 제공할 것으로 기대한다.

 

#### Ⅱ. 방법 및 사용도구

 

1. 아미노산 서열 정보 출처

본 웹 application에서 가지고 있는 아미노산 서열 정보의 출처는 NCBI (https://www.ncbi.nlm.nih.gov/)이다. 데이터베이스를 생성할 때는 2023년 06월 10일 NCBI의 분류항목에서 chloroplast와 protein항목을 선택해서 나오는 데이터들로 구성하였다. 데이터의 관리 및 검색의 용이함을 위해 xml형식으로 다운 받은 데이터들을 태그별로 분리하여 저장하였다.

 

2. 서열 정렬 방법

다중시퀀스정렬(MSA)을 하는 도구들에는 여러 가지가 있지만 본 웹 application에서는 MUSCLE을 사용하였다. MUSCLE은 다중시퀀스정렬을 하는데 자주 사용되는 프로그램이며, 대규모로 정렬을 수행할 수 있고 사용자에게 수행 결과에 대한 다양한 옵션을 제공한다. 본 웹 application은 아래와 같은 3가지 방법을 서버에 내장해놓았으며 사용자가 하나를 선택하여 분석할 수 있게 설계를 하였다.

첫 번째로 Maximum Likelihood는 주어진 서열의 초기 집합에서 가능한 모든 트리를 검토하는 방법으로, 서열들을 가장 진화적으로 잘 설명할 수 있는 생물계통을 통계적으로 찾아내는 것이다. 즉, 가능한 진화적 변화에 대한 확률을 모두 계산하여 가능성을 최대화함으로써 최적의 선택을 찾는다.5)

두 번째로 UPGMA는 공동 조상으로부터 기원된 상동성(homologous) 특징이 진화 시간을 거쳐 점차 다르게 분화되어 간다는 점에 따라, 서로 비슷한 특징을 가질수록 더 가까이 연관되어 있다는 생각에서 나온 방법론이다. 분석하고자 하는 분류군 중 가장 가까운 관계 둘을 찾아 하나의 새로운 군(cluster)으로 묶어 나가는 것을 반복하는 것으로 진행된다.6)

마지막으로 Neighbor Joining은 거리 계산 방법중 하나로, UPGMA법을 사용할 때 생길 수 있는 오류를 제거할 수 있다. UPGMA는 거리를 기준으로 가장 가까운 가지들이 이웃하는 트리를 만든다. 이러한 방식은 트리를 제한하여 어떤 상황에는 잘못된 트리를 만들 수도 있다. 이런 문제를 해결하기 위해 Neighbor Joining알고리즘은 단지 거리 계산에 의한 최소쌍 거리만 찾는 것이 아니라 트리의 전체 길이를 최소화하는 이웃의 집합을 탐색한다.7)

MUSCLE은 다중시퀀스정렬을 수행하는 것에서부터 Newick format을 만드는 것까지 모든 것을 수행한다. 이 때 MUSCLE의 모든 파라미터값은 기본값으로 설정되었다. MUSCLE은 다중시퀀스정렬(MSA) 결과 파일까지는 동일하게 수행하며 method에 관련된 명령어는 사용자가 선택함에 따라 Maximum Likelihood, UPGMA, Neighbor Joining 중에서 1개가 실행된다.

 

3. jsPhyloSVG

jsPhyloSVG는 Newick format 또는 phyloXML형식에서 SVG(Scalable Vector Graphics) 형식의 브라우저 내에서 계통수를 생성해주는 자바스크립트 라이브러리이다. jsPhyloSVG는 Newick format을 렌더링 할 때는 최대 레이블, 가장자리 길이 및 부트스트랩 값만 포함한다. 본 웹 application에서는 MUSCLE의 최종 결과로 Newick format을 반환한다. 반환된 데이터를 jsPhyloSVG를 이용하면 사용자의 화면에서 계통수를 볼 수 있다.9)


#### Ⅲ. 결과 및 고찰

 

1. EasyTree의 work flow

 


그림 1. work flow
 

앞서 언급한 재료 및 방법으로 구현한 EasyTree의 work flow를 살펴보면 다음과 같다. 클라이언트는 이 웹서비스를 이용하는 사용자의 컴퓨터를 의미하고 AWS EC2 instance는 서버컴퓨터를 의미한다. 서버컴퓨터 안에는 Web Application Server(WAS)와 MySQL이 있다. WAS는 웹서버를 의미하여 이 안에서 실제 프로그램이 수행된다. MySQL은 데이터베이스를 의미하며 이 안에 식물들의 protein 서열정보들이 담겨있다. WAS안에 MUSCLE은 MUSCLE실행프로그램이며 이것을 통해 다중시퀀스정렬을 수행한다. (그림 1)

프로그램의 수행과정은 다음과 같다. 사용자가 클라이언트에서 요청을 하면 입력된 데이터와 사용자가 선택한 데이터를 기반으로 INPUT FILE이 만들어진다. INPUT FILE은 하나의 파일에 사용자가 선택한 protein 서열들과 사용자가 입력한 protein 서열들이 FASTA형식으로 있다.

이후에 MUSCLE에서 다중시퀀스정렬을 수행하는 명령어가 서버에서 자동으로 실행되며 INPUT FILE을 통해 MSA가 만들어진다. MSA는 INPUT FILE의 데이터들이 다중시퀀스정렬 작업을 마친 파일이다. MSA RESULT FILE은 다중시퀀스정렬의 수행결과를 화면에 보여주는 HTML파일이다. NEWICK FORMAT은 jsPhyloSVG을 통해 계통수를 렌더링하기 위한 파일이다. 이렇게 만들어진 MSA RESULT FILE과 NEWICK FORMAT의 결과가 클라이언트에게 전송되며, 사용자는 다중시퀀스정렬결과와 NEWICK FORMAT에 기반한 계통수를 볼 수 있게 되는 것이다.

 

2. 사용 매뉴얼


그림 2. 화면구성
 

메인화면에서 서열정보들은 학명, NCBI코드, protein이름으로 구성되어있다. NCBI코드를 클릭하면 해당 서열정보의 출처로 이동할 수 있으며 protein이름을 클릭하면 본 웹에 저장되어있는 FASTA포맷을 볼 수 있다. 사용자는 분석하고자 하는 서열 데이터를 선택할 수 있다. 이후에 트리보기 버튼을 클릭하여 자신이 선택한 서열 데이터를 확인할 수 있다. FASTA포맷 칸에는 사용자가 원하는 서열 데이터를 가져와 FASTA포맷으로 입력하면 사용자가 선택한 데이터와 같이 분석할 수 있다. 이후에 트리방식에서 Maximum Likelihood, Neighbor-Joining, UPGMA 중 1개를 선택하여 결과보기 버튼을 누르면 사용자가 원하는 서열 데이터 간의 계통수를 볼 수 있다. (그림 2)

 


그림 3. 계통수 결과
 

위 화면은 계통수를 보여주는 결과화면이다. 가장 가운데에는 계통수가 그려져있으며 그 아래에는 계통수를 문자열형식으로 표현한 Newick format을 보여주고 있다. 결과화면에는 다중시퀀스정렬결과를 볼 수 있는 정렬결과버튼과 Newick format을 파일로 다운받을 수 있는 다운로드 버튼이 있다. (그림 3)

 


그림 4. 정렬결과
 

정렬결과를 눌렀을 때의 화면이다. 서열 데이터에는 아미노산 치환이 보존적인지 비보존적인지를 알 수 있는 BLOSUM62 점수가 반영되어있다. 연한 파란색의 경우에는 3점보다 크거나 같은 경우로 보존적 치환임을 나타낸다. 밝은 회색과 그 외에 색깔이 지정되어있지 않은 문자열은 0.2점보다 낮은 점수를 가지고 있는 문자열임을 의미한다. 즉, 비보존적 치환임을 나타낸다.(그림 4)

 

3. EasyTree의 작업 수행 시간


그림 5. 작업 수행 시간
 

위 그래프는 EasyTree에서 1000base pair기준으로 Maximum-Likelihood, Neighbor-Joining, UPGMA의 작업시간을 측정한 결과이다. 서열개수가 5개일때는 4초내외의 시간이 걸렸으며 서열개수가 14개가 넘어가면 30초내외의 시간이 걸린다.(그림 5) 본 application은 aws에서의 t2.micro에서 실행되고 있다. (vCPU:1, 아키텍처:i386, x86_64, 메모리(GB):1, 네트워크성능:Low to Moderate) application에서 분석할 때의 서열의 개수는 최대 15개로 제한하였으며 각 서열별 base pair는 1000개 내외로 할 것을 권장한다.

 

4. 다른 연구와의 비교


그림 6. 이전 연구에서의 Pinus속에 대한 계통분석 연구와의 비교
 

위의 왼쪽 그림은 EasyTree에서 엽록체에 있는 Maturase K 단백질에 대하여 계통수를 UPGMA방식으로 분석한 그림이다. 오른쪽 그림은 Ann Willyard(2007)가 동일한 12개의 수종으로 4개 핵의 silent site 대해서 계통수를 그린 결과이다.13) 먼저, Ann Willyard의 계통수 결과를 보면 크게 Pinus subgenus와 Strobus subgenus로 2개의 clade로 형성된다. Pinus subgenus에서는 2개의 clade로 형성되었다. Pinus taeda, Pinus radiata, Pinus ponserosa, Pinus contorta는 Trifoliae section으로 분류되었고, Pinus merkusii, Pinus roxburghii는 Pinus section으로 분류되었다. 또한 Strobus subgenus에서도 2개의 clade로 형성되었다. Pinus krempfii, Pinus gerardiana, Pinus monticola는 Quinquefoliae section으로 분류되었고, Pinus nelsonii, Pinus longaeva, Pinus monophylla는 Parrya section으로 분류되었다. EasyTree의 결과를 보면 마찬가지로 크게 Pinus subgenus와 Strobus subgenus로 2개의 clade로 형성된다. Pinus subgenus에서는 Pinus taeda, Pinus radiata, Pinus ponserosa, Pinus contorta를 하나의 clade로 형성하여 Trifoliae section으로 분류하였다. Strobus subgenus에서는 Pinus krempfii, Pinus gerardiana를 하나의 clade로 형성하여 Quinquefoliae section으로 분류하였다. 또한, Pinus nelsonii, Pinus longaeva, Pinus monophylla를 하나의 clade로 형성하여 Parrya section에 대해서도 구분하였다. 다른 서열 데이터를 분석하였음에도 EasyTree는 subgenus의 분류, section의 분류를 수행할 수 있는 모습을 보인다.(그림 6)

 

5. 상용 프로그램과의 비교


그림7. MEGA11와 EasyTree간의 계통분석 비교
 

EasyTree에서 사용한 데이터(Maturase K)와 동일한 데이터로 MEGA11에서 UPGMA방식으로 분석한 결과를 비교한 그림이다.(그림 7) MEGA11의 분석결과와 비교를 해보면 Pinus monticola의 분기점을 제외하고는 모든 분기점이 일치한다. 따라서, Easytree가 Pinus subgenus와 Strobus subgenus의 분류와 각 하위 section인 Trifoliae section, Quinquefoliae section, Parrya section, Pinus section의 분류를 정확하게 수행하였음을 알 수 있다.

EasyTree에서의 계통수와 MEGA11에서의 계통수가 동일한 데이터를 사용하여 분석을 했음에도 불구하고 미세한 차이가 나는 이유는 정렬을 수행할 때의 파라미터값의 차이에 있다. MEGA11 자체에서 사용하고 있는 파라미터와 MUSCLE의 파라미터값이 다르기 때문에 미세한 차이가 나왔고 그 결과가 계통수에도 영향을 미친 것이다. MEGA11에서 정렬을 수행할 때의 파라미터값들은 Gap Open : -2.9, Gap Extend : 0.0, Hydrophobicity Multiplier : 1.2, Max Memory in MB : 2048, Max iterations : 16, Cluster Method (interation 1,2) : UPGMA, Cluster Method (Other iterations) : UPGMA, Min Diag Length (Lambda) : 24로 총 8가지만을 기본으로 제공하고 있으며10), MUSCLE에서 제공하고 있는 파라미터값들은 28가지를 기본으로 제공하고 있다.11) 이러한 파라미터의 차이 때문에 계통수의 차이가 있었음을 추측해 볼 수 있다. 따라서 EasyTree로 계통수를 분석할 때 파라미터의 차이에 따라 상용프로그램과의 계통수 차이가 있음을 알 수 있다.

 

6. EasyTree의 단점 및 보완 방향

EasyTree는 사용자의 분석 자유도 측면에서 미흡한 부분들이 존재한다. (1) 서버의 낮은 용량으로 NCBI에 존재하는 모든 데이터들을 저장할 수 없다. 따라서 사용자는 데이터베이스에 있는 서열 데이터 외의 데이터를 분석하고자 할 때 번거로운 점이 있다. (2) rectangular phylograms만 렌더링이 가능하므로 사용자는 동일한 종류의 계통수만 볼 수 있다. (3) 사용자가 다중시퀀스정렬을 수행할 때의 파라미터 값을 설정할 수 없으므로 일관된 정렬만을 수행할 수 있다. (4) 서버의 적은 메모리로 인한 1000base pair이상의 서열데이터 분석에 어려움이 있다. (5) 다중시퀀스정렬 method가 3개로만 구성되어 있어서 다각도의 분석이 제한되어있다. (6) 다중시퀀스정렬을 MUSCLE로만 수행할 수 있어서 사용자의 알고리즘 선택에 강제성이 부여된다.

따라서 EasyTree가 가지고 있는 단점에 기반하여 보완방향을 제시해보면 다음과 같다. (1) NCBI에 있는 모든 데이터를 담을 수 있는 데이터베이스 서버를 구축해야한다. (2) circular phylograms 등 다른 방식의 계통수도 지원하는 라이브러리를 이용 또는 개발해야한다. (3) 사용자가 다중시퀀스정렬을 수행할 때의 파라미터값을 customizing 할 수 있도록 설계해야 한다. (4) 1000base pair이상의 서열데이터를 분석할 수 있기 위한 고성능 서버를 구축하고 work flow를 최적화해야 한다. (5) Minimum-Evolution 등 다른 method도 추가하여 사용자의 분석 제한을 완화한다. (6) ClustalW 등 다른 알고리즘을 선택할 수 있도록 설계하여 알고리즘 선택에 자유도를 증가시킨다. 이와 같은 개선점을 적용하면 사용자의 분석 방향의 자율성을 증대시킬 수 있으며 연구를 함에 있어서 제약이 줄어들게 된다.

 

#### Ⅴ. 결론

 

본 웹 application은 생명정보학에서의 계통수 분석의 편리함을 위해서 컴퓨터를 다루는 모든 과정을 생략하였다. 기존의 프로그램들은 사용자가 직접 서열 데이터를 수집해야 한다. 게다가, 다중시퀀스정렬을 수행하여야 하고, 정렬결과를 바탕으로 계통수 분석까지 해야 사용자가 원하는 계통수를 볼 수 있다. 하지만 EasyTree는 이 모든 과정을 서버에 통합하여 사용자의 편리함을 극대화하였다.

또한, 웹 application의 구성을 한글로 만들었고, 한글로 사용법까지 자세하게 만들어서 생명정보학에 관심이 있는 사람들이 쉽게 접근할 수 있도록 하였다. 접근이 쉬워진만큼 더 많은 사람들이 생명정보학을 접할 수 있으며 이는 곧 생명정보학의 발전으로 이어질 수 있다.

산림분야에서는 아직 많은 연구가 안 된 산림유전자 관련 연구에 기여할 수 있다. 즉, 산림생물정보학의 학습 및 연구의 시간이 단축될 수 있고, 단축된 시간만큼 더 많은 연구가 이루어져 산림 분야의 많은 발전을 바라볼 수 있다. 향후 산림관련 연구에서 우리나라가 앞으로 나아갈 발판이 생긴 것이다.

 

#### Ⅵ. 참고문헌

 

1. 생물학연구정보센터 (2002). 2002 한국의 생물정보학 백서. 한올출판사.

 

2. 정동수, 박준호 (2006). 국내 생물정보학(Bioinformatics)의 연구현황. 한국공업학회지, 9(5), 11-21.

 

3. 최현숙, 2013, 과학영재의 독립연구 수행능력 신장을 위한 생명정보학 활용 교수-학습 프로그램 개발 및 적용 = A Study on the Utilization of Bioinformatics for the Improvement of the Independent Research Skills of Scientifically Gifted Students: the development and application of teaching-learning(석사학위논문, 한국교원대학교), http://www.riss.kr/link?id=T13091634

 

4. 김태경, 김훈기, 최치환, 정승현, 허보경, 조완섭, 2010, 웹 기반 고성능 다중서열정렬시스템 설계 및 구현, 한국컴퓨터정보학회 하계학술대회 논문집, 18(2), 80

 

5. Pawel Górecki, Gordon J Burleigh, Oliver Eulenstein, 2011, BMC Bioinformatics,https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-S1-S15

 

6. Sharma R., 2019, medium, https://medium.com/@sharma.ravit/upgma-method-designing-a-phylogenetic-tree-9a708de18419

 

7. Sharma R., 2022, medium,https://medium.com/@MarinaBioinfoStarter/29-additive-trees-and-the-neighbour-joining-algorithm-87bea218e39c

 

8. Edgar, RC (2021), MUSCLE v5 enables improved estimates of phylogenetic tree confidence by ensemble bootstrapping, bioRxiv 2021.06.20.449169. https://doi.org/10.1101/2021.06.20.449169.

 

9. Smits SA, Ouverney CC, 2010. jsPhyloSVG: A Javascript Library for Visualizing Interactive and Vector-Based Phylogenetic Trees on the Web. PLoS ONE 5(8): e12267. doi:10.1371/journal.pone.0012267

 

 

10. MEGA, n.d, https://www.megasoftware.net/web_help_11/index.htm#t=Part_II_Assembling_Data_For_Analysis%2FBuilding_Sequence_Alignments%2FMUSCLE%2FMUSCLE_Options_(Protein).htm&rhsearch=parameter&rhhlterm=parameter&rhsyns=%20

 

11. MUSCLE, n.d, https://www.drive5.com/muscle/muscle.html

 

12. LabXchange, 2021, https://www.labxchange.org/library/items/lb:LabXchange:24d0ec21:lx_image:1

 

13. Ann Willyard, 2007, Fossil Calibration of Molecular Divergence Infers a Moderate Mutation Rate and Recent Radiations for Pinus, Molecular biology and evolution, Vol.24 No.1 [2007], 90-101


