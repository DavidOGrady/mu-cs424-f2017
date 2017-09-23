;;; <identifier> ::= <id-char>+    (except not a number)
;;; <id-char> ::= 'a' | 'b' | ... | '0' | '-' | '_' | ...

;;; <number> ::= ...

;;; <expr> ::= <variable>
;;;            | <number>
;;;            | <funcall>
;;;            | <special form>

;;; <funcall> ::= '(' <expr> <expr>* ')'

;;; <special form> ::= '(' <magic keyword> ... ')'
;;; <magic keyword> ::= 'define' | 'lambda' | 'λ'
;;;          | 'if'

;;; <λ expr> ::= '(λ (' <id>+ ')' <expr> ')'
;;; <if expr> ::= '(if' <expr> <expr> <expr>')'

(define hypot
  (λ (x y)
    (sqrt (+ (* x x)
	     (* y y)))))

;;; compose, composition
(define comp (λ (f g) (λ (x) (f (g x)))))

;;; Recursive definition of factorial:
;;;  0! = 1
;;;  1! = 1        (bad base case)
;;;  n! = n * (n-1)!   (for n>0)

(define fact
  (λ (n)
    (if (= n 0)
	1
	(* n (fact (- n 1))))))

;;; (iterate n f x) applies f to x n times
;;; (iterate 2 f x) = f(f(x))
;;; (iterate 1 f x) = f(x)
;;; (iterate 0 f x) = x

(define iterate
  (λ (n f x)
    (if (= n 0)
	x
	(f (iterate (- n 1) f x)))))

;;; sqrt(x) - calculate by iterating
;;;     guess: y
;;;     replace w/ better guess: average of y, (x/y)

(define my-sqrt
  (λ (x)
    (iterate 200
	     (λ (y) (/ (+ y (/ x y)) 2))
	     (/ x 2))))

;;;;;; transcript

;; Welcome to Racket v6.9.
;; > +
;; #<procedure:+>
;; > 17
;; 17
;; > 17.0
;; 17.0
;; > 17.0e27
;; 1.7e+28
;; > -4
;; -4
;; > 12/3
;; 4
;; > 3/12
;; 1/4
;; > 0.25
;; 0.25
;; > sin
;; #<procedure:sin>
;; > 2
;; 2
;; > (sin 2)
;; 0.9092974268256817
;; > (+ 2 3)
;; 5
;; > (expt 2 1000)
;; 10715086071862673209484250490600018105614048117055336074437503883703510511249361224931983788156958581275946729175531468251871452856923140435984577574698574803934567774824230985421074605062371141877954182153046474983581941267398767559165543946077062914571196477686542167660429831652624386837205668069376
;; > (/ (expt 2 1000) (expt 2 998))
;; 4
;; > (+ 2 3 4)
;; 9
;; > (+ 2 3 4 5 6 7 8)
;; 35
;; > (+ 2)
;; 2
;; > (+)
;; 0
;; > (* 2 3)
;; 6
;; > (/ 2 3.0)
;; 0.6666666666666666
;; > pi
;; 3.141592653589793
;; > tau
;; ; tau: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (define tau (* 2 pi))
;; > tau
;; 6.283185307179586
;; > (λ (x) (+ x 1))
;; #<procedure>
;; > (  (λ (x) (+ x 1))        7)
;; 8
;; > hypot
;; ; hypot: undefined;
;; ;  cannot reference undefined identifier
;; ; [,bt for context]
;; > (load "lecture-02.scm")
;; > hypot
;; #<procedure:hypot>
;; > (hypot 3 4)
;; 5
;; > (load "lecture-02.scm")
;; > ((comp sqrt sqrt) 16)
;; 2
;; > =
;; #<procedure:=>
;; > (= 0 1)
;; #f
;; > (if (= 0 1) 27 36)
;; 36
;; > (= 0 0)
;; #t
;; > (if (= 0 0) 27 36)
;; 27
;; > (if #f 27 36)
;; 36
;; > (if #t 27 36)
;; 27
;; > (if 0 27 36)
;; 27
;; > (load "lecture-02.scm")
;; > (fact 0)
;; 1
;; > (fact 1)
;; 1
;; > (fact 2)
;; 2
;; > (fact 200)
;; 788657867364790503552363213932185062295135977687173263294742533244359449963403342920304284011984623904177212138919638830257642790242637105061926624952829931113462857270763317237396988943922445621451664240254033291864131227428294853277524242407573903240321257405579568660226031904170324062351700858796178922222789623703897374720000000000000000000000000000000000000000000000000
;; > (fact 2000)
;; 331627509245063324117539338057632403828111720810578039457193543706038077905600822400273230859732592255402352941225834109258084817415293796131386633526343688905634058556163940605117252571870647856393544045405243957467037674108722970434684158343752431580877533645127487995436859247408032408946561507233250652797655757179671536718689359056112815871601717232657156110004214012420433842573712700175883547796899921283528996665853405579854903657366350133386550401172012152635488038268152152246920995206031564418565480675946497051552288205234899995726450814065536678969532101467622671332026831552205194494461618239275204026529722631502574752048296064750927394165856283531779574482876314596450373991327334177263608852490093506621610144459709412707821313732563831572302019949914958316470942774473870327985549674298608839376326824152478834387469595829257740574539837501585815468136294217949972399813599481016556563876034227312912250384709872909626622461971076605931550201895135583165357871492290916779049702247094611937607785165110684432255905648736266530377384650390788049524600712549402614566072254136302754913671583406097831074945282217490781347709693241556111339828051358600690594619965257310741177081519922564516778571458056602185654760952377463016679422488444485798349801548032620829890965857381751888619376692828279888453584639896594213952984465291092009103710046149449915828588050761867924946385180879874512891408019340074625920057098729578599643650655895612410231018690556060308783629110505601245908998383410799367902052076858669183477906558544700148692656924631933337612428097420067172846361939249698628468719993450393889367270487127172734561700354867477509102955523953547941107421913301356819541091941462766417542161587625262858089801222443890248677182054959415751991701271767571787495861619665931878855141835782092601482071777331735396034304969082070589958701381980813035590160762908388574561288217698136182483576739218303118414719133986892842344000779246691209766731651433494437473235636572048844478331854941693030124531676232745367879322847473824485092283139952509732505979127031047683601481191102229253372697693823670057565612400290576043852852902937606479533458179666123839605262549107186663869354766108455046198102084050635827676526589492393249519685954171672419329530683673495544004586359838161043059449826627530605423580755894108278880427825951089880635410567917950974017780688782869810219010900148352061688883720250310665922068601483649830532782088263536558043605686781284169217133047141176312175895777122637584753123517230990549829210134687304205898014418063875382664169897704237759406280877253702265426530580862379301422675821187143502918637636340300173251818262076039747369595202642632364145446851113427202150458383851010136941313034856221916631623892632765815355011276307825059969158824533457435437863683173730673296589355199694458236873508830278657700879749889992343555566240682834763784685183844973648873952475103224222110561201295829657191368108693825475764118886879346725191246192151144738836269591643672490071653428228152661247800463922544945170363723627940757784542091048305461656190622174286981602973324046520201992813854882681951007282869701070737500927666487502174775372742351508748246720274170031581122805896178122160747437947510950620938556674581252518376682157712807861499255876132352950422346387878954850885764466136290394127665978044202092281337987115900896264878942413210454925003566670632909441579372986743421470507213588932019580723064781498429522595589012754823971773325722910325760929790733299545056388362640474650245080809469116072632087494143973000704111418595530278827357654819182002449697761111346318195282761590964189790958117338627206088910432945244978535147014112442143055486089639578378347325323595763291438925288393986256273242862775563140463830389168421633113445636309571965978466338551492316196335675355138403425804162919837822266909521770153175338730284610841886554138329171951332117895728541662084823682817932512931237521541926970269703299477643823386483008871530373405666383868294088487730721762268849023084934661194260180272613802108005078215741006054848201347859578102770707780655512772540501674332396066253216415004808772403047611929032210154385353138685538486425570790795341176519571188683739880683895792743749683498142923292196309777090143936843655333359307820181312993455024206044563340578606962471961505603394899523321800434359967256623927196435402872055475012079854331970674797313126813523653744085662263206768837585132782896252333284341812977624697079543436003492343159239674763638912115285406657783646213911247447051255226342701239527018127045491648045932248108858674600952306793175967755581011679940005249806303763141344412269037034987355799916009259248075052485541568266281760815446308305406677412630124441864204108373119093130001154470560277773724378067188899770851056727276781247198832857695844217588895160467868204810010047816462358220838532488134270834079868486632162720208823308727819085378845469131556021728873121907393965209260229101477527080930865364979858554010577450279289814603688431821508637246216967872282169347370599286277112447690920902988320166830170273420259765671709863311216349502171264426827119650264054228231759630874475301847194095524263411498469508073390080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
;; > (/ (fact 2000) (fact 1999))
;; 2000
;; > (/ (fact 20000) (fact 19999))
;; 20000
;; > compose
;; #<procedure:compose>
;; > map
;; #<procedure:map>
;; > (load "lecture-02.scm")
;; > (iterate 0 sin 1)
;; 1
;; > (iterate 1 sin 1)
;; 0.8414709848078965
;; > (iterate 10 sin 1)
;; 0.46295789853781183
;; > (iterate 100 sin 1)
;; 0.16885248872798111
;; > (iterate 1000 sin 1)
;; 0.054592971510185134
;; > (iterate 1 cos 1)
;; 0.5403023058681398
;; > (iterate 10 cos 1)
;; 0.7442373549005569
;; > (iterate 100 cos 1)
;; 0.7390851332151607
;; > (iterate 1000 cos 1)
;; 0.7390851332151607
;; > (load "lecture-02.scm")
;; > (my-sqrt 4.0)
;; 3.8091670731664637e-121
;; > (load "lecture-02.scm")
;; > (my-sqrt 4.0)
;; 2.0
;; > (my-sqrt 10.0)
;; 3.162277660168379