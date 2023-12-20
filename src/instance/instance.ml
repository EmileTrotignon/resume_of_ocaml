open Resume_lib
open Multi_string
open Runtime_template
open Makers

let emile =
  Resume.make ~firstname:(I "Émile") ~lastname:(I "Trotignon")
    ~intro:
      (v
         ~french:
           "Étudiant en informatique à l'ENS Paris-Saclay, je suis très \
            interessé par OCaml et plus généralement par les langues de \
            programmation et la compilation."
         ~english:
           "As a master's student in Computer Science at ENS Paris-Saclay, I \
            am very interested in OCaml, programming languages and \
            compilation." )
    ~formations:
      [ formation (I "École Normale Supérieure Paris-Saclay")
          (v ~french:"Master Parisien de Recherche en Informatique"
             ~english:"Master's degree in Computer Science Research (MPRI)" )
          ~date_start:(I "2020") ~date_end:(I "2022")
      ; formation (I "École Normale Supérieure Paris-Saclay")
          (v ~french:"L3 Informatique" ~english:"Bachelor in Computer Science")
          ~date_start:(I "2019") ~date_end:(I "2020")
      ; formation (I "Université Lyon 1 Claude-Bernard")
          (v ~french:"L2 Informatique - mathématiques"
             ~english:
               "Second year of Bachelor in Computer Science and Mathematics" )
          ~date_start:(I "2018") ~date_end:(I "2019")
      ; formation
          (v ~french:"Lycée Jean Perrin (Option Informatique au Lycée du Parc)"
             ~english:"Jean-Perrin preparatory school" )
          (v ~french:"CPGE MPSI"
             ~english:"First year of Bachelor in engineering" )
          ~date_start:(I "2017") ~date_end:(I "2018")
      ; formation (I "Lycée La Trinité")
          (v ~french:"Baccalauréat scientifique"
             ~english:"High school diploma with science focus" )
          ~date_start:(I "2016") ~date_end:(I "2017") ~location:(I "Lyon")
          ~result:(v ~french:"Mention Très Bien" ~english:"with honours") ]
    ~experiences:
      [ experience
          (v ~french:"Stage de recherche en informatique"
             ~english:"Research internship in computer science" )
          ~description:
            (v
               ~french:
                 (atom
                    "Stage de 4.5 mois supervisé par Vincent Laviron et Pierre \
                     Chambart. Généralisation de l'optimisation des appel \
                     récursifs en queue modulo constructeurs." )
               ~english:
                 (atom
                    "4.5-month intership tutored by Vincent Laviron and Pierre \
                     Chambart. Generalisation of recursive tail-call \
                     optimisation modulo constructor" ) )
          (v ~french:"OCamlpro, équipe Flambda"
             ~english:"OCamlpro, team Flambda" )
          ~location:(I "Paris, France")
          (v ~french:"Printemps 2022" ~english:"Spring 2022")
      ; experience
          (v ~french:"Stage de recherche en informatique"
             ~english:"Research internship in computer science" )
          ~description:
            (v
               ~french:
                 (atom
                    "Stage de M1 de 5 mois encadré par François Pottier. \
                     Améliorations de Menhir, un générateur de parser LR(1) \
                     pour OCaml :\n\
                     Augmentation de la sécurité grâce aux GADTs, ce qui \
                     autorises des optimisation plus aggresives. Nombre \
                     d'allocations divisée par 4 et vitesse augmentée de 10%, \
                     sur des grammaires variées. " )
               ~english:
                 (atom
                    "Five-month internship tutored by François Pottier. \
                     Improvements the code generated by Menhir, the LR(1) \
                     parser generator for OCaml :\n\
                     Typing with GADTs for increased safety, allowing bolder \
                     optimisations. The number of allocations was divided by \
                     4, and the speed increased by 10%, across various \
                     grammars." ) )
          (v ~french:"Inria Paris, équipe Cambium"
             ~english:"Inria Paris, team Cambium" )
          ~location:(I "Paris, France")
          (v ~french:"Printemps 2021" ~english:"Spring 2021")
      ; experience
          (v ~french:"Stage de recherche en géometrie algorithmique"
             ~english:"Research internship in computational geometry" )
          ~description:
            (v
               ~french:
                 [ S
                     "Stage de 6 semaines encadré par David Coeurjolly and \
                      Vincent Nivoliers. Le sujet du stage était \
                      d'échantillonner la surface d'une mesh potentiellement \
                      défectueuse. J'ai beaucoup programmé en C++ pendant ces \
                      six semaines. J'ai utilisés des outils tels que \
                      Polyscope et LIBIGL. Mon rapport de stage est disponible \
                      à cette adresse : "
                 ; f "url" "https://emiletrotignon.github.io//files/rapport.pdf"
                 ]
               ~english:
                 [ S
                     "Six weeks internship tutored by David Coeurjolly and \
                      Vincent Nivoliers. My goal during this internship was to \
                      uniformly sample the surface of a potentially imperfect \
                      mesh. During the six weeks, I spent a good portion of my \
                      time programming in C++ and I used tools such as \
                      Polyscope and LIBIGL. My internship report is available \
                      here: "
                 ; f "url" "https://emiletrotignon.github.io/files/rapport.pdf"
                 ] )
          (v ~french:"Laboratoire LIRIS" ~english:"LIRIS laboratory")
          ~location:(I "Lyon, France")
          (v ~french:"Été 2020" ~english:"Summer 2020")
      ; experience
          (v ~french:"Développeur Node.js fullstack"
             ~english:"Fullstack Node.js developer" )
          ~description:
            (v
               ~french:
                 [ S
                     "Dans le cadre d'un mission pour la junior entreprise de \
                      l'ENS Paris-Saclay de 6 semaines, j'ai participé au \
                      développement du site web d'Expert People, une nouvelle \
                      plateforme de freelancing. Les technologies utilisées \
                      sont Node.js et Express.js. J'ai notamment mis en place \
                      un système pour remplir automatiquement le formulaire de \
                      CV d'un utilisateur avec son CV Linkedin sous format PDF.\n\
                      Le site d'Expert People : "
                 ; f "url" "https://expertpeople.co/" ]
               ~english:
                 [ S
                     "During a six week mission for the junior entreprise of \
                      ENS Paris-Saclay, I contributed to the website \
                      development of Expert People, a new freelancing \
                      platform. The technologies used were Node.js and \
                      Express.js. One of my achievements was parsing LinkedIn \
                      resumes in PDF format to auto-fill the resume form.\n\
                      Expert People's website (in french) : "
                 ; f "url" "https://expertpeople.co/" ] )
          (v ~french:"Junior entreprise de l'ENS Paris-Saclay"
             ~english:"Junior entreprise of ENS Paris-Saclay" )
          (v ~french:"Mars 2020" ~english:"March 2020")
      ; experience (I "ICPC SWERC 2019-2020") (I "")
          (v ~french:"Janvier 2020" ~english:"January 2020")
          ~location:(I "Télécom Paris")
          ~description:
            (v
               ~french:
                 [ S
                     "Compétition de programmation/algorithmique universitaire.\n\
                      Participation au sein d'une équipe de trois.\n\
                      Classement de mon équipe : 37 sur 95 équipes \
                      répresentant des universités de plusieurs pays \
                      européens." ]
               ~english:
                 [ S
                     "University programming/algorithms competition.\n\
                      Participation in teams of three students.\n\
                      Ranked 37th of 95 teams representing universities from \
                      multiple european countries." ] )
      ; experience
          (v ~french:"Développeur stagiaire C#" ~english:"Intern C# developer")
          (I "Eternix Ldt.")
          (v ~french:"Été 2019" ~english:"Summer 2019")
          ~location:(I "Tel Aviv, Israel")
          ~description:
            (v
               ~french:
                 [ S
                     "Stage de 2 mois. Écriture de shaders HLSL, découverte de \
                      DirectX, Windows Form, expérience avec OpenCV.\n\
                      Expérience extrêmement enrichissante dans une entreprise \
                      étrangère" ]
               ~english:
                 [ S
                     "Two month internship. HSLS shaders, introduction to \
                      DirectX and OpenCV, Windows Form development.\n\
                      Greatly rewarding experience abroad." ] )
      ; experience
          (v ~french:"Développeur front-end" ~english:"Front end developer")
          (I
             "École Nationale Supérieure des Sciences de l'Information et des \
              Bibliothèques" )
          (v ~french:"Juillet 2018" ~english:"July 2018")
          ~location:(I "Lyon, France")
          ~description:
            (v
               ~french:
                 [ S
                     " Lors d'un emploi estival d'un mois, j'ai contribué à \
                      l'intégration du nouveau site web de l'ENSSIB. Le \
                      nouveau site est visible ici :"
                 ; f "url" "http://www.enssib.fr/" ]
               ~english:
                 [ S
                     "For a month, I contributed to the graphical integration \
                      of the new website for ENSSIB, the French school for \
                      library curators. You can see their website here: "
                 ; f "url" "http://www.enssib.fr/" ] ) ]
    ~languages:
      [ Language.make (v ~french:"Anglais" ~english:"English") Strong
      ; Language.make (v ~french:"Français" ~english:"French") VeryStrong ]
    ~skills:
      [ skill (I "Compilation") Strong
          ~description:
            (v
               ~french:
                 [ S
                     "La compilation des langages de programmation est un \
                      sujet qui m'intéresse beaucoup. Dans ce domaine, j'ai \
                      écris un type checker pour le système de type f-omega \
                      lors d'un cours de M2. Le code est disponible ici :"
                 ; f "url" "https://github.com/EmileTrotignon/f-omega"
                 ; S
                     "Lors d'un cours de M1 j'ai écris un compilateur pour un \
                      language de programmation du style ML vers X86."
                 ; S ".\nLe code est disponilble ici: "
                 ; f "url"
                     "https://github.com/EmileTrotignon/cours-compilation-p7"
                 ; S
                     ".\n\
                      J'ai aussi programmé en 2019 un compilateur pour un \
                      sous-ensemble du langage C vers X86: "
                 ; f "url" "https://github.com/EmileTrotignon/mcc" ]
               ~english:
                 [ S
                     "I am very interested in compilation. In this domain, for \
                      a M2 course, I have written a type checker for the \
                      f-omega type system. The code is available here:"
                 ; f "url" "https://github.com/EmileTrotignon/f-omega"
                 ; S
                     ".\n\
                      For a M1 course, I have written a compiler for an \
                      ML-style langage to X86. The code is available here:"
                 ; f "url"
                     "https://github.com/EmileTrotignon/cours-compilation-p7"
                 ; S
                     ".\n\
                      I have also programmed a compiler for a subset of the C \
                      language to X86 in 2019: "
                 ; f "url" "https://github.com/EmileTrotignon/mcc" ] )
      ; skill
          (v ~french:"Informatique fondamentale"
             ~english:"Fundamental Computer Science" )
          Strong
          ~description:
            (v
               ~french:
                 [ S
                     "Durant mes études, j'ai étudié différents aspects de \
                      l'informatique théorique :\n\
                      Sémantique des langages de programmation, théorie du \
                      calcul parallèle en mémoire partagée, langages formels, \
                      calculabilité, logique.\n\
                      Cela m'apporte beaucoup dans ma compréhension de \
                      l'informatique en général, en plus des compétences \
                      spécifiques à chaque domaine." ]
               ~english:
                 [ S
                     "I have studied different aspect of fundamental Computer \
                      Science :\n\
                      Programming languages semantics, theory of parallel \
                      computing with shared memory, formal languages, \
                      calculability, logic.\n\
                      This enhances my understanding of computer science in \
                      general, in addition to the particular skills acquired."
                 ] )
      ; skill
          (v ~english:"Functionnal programming"
             ~french:"Programmation fonctionnelle" )
          VeryStrong
          ~description:
            (v
               ~french:
                 [ S
                     "J'aime beaucoup les langages de programmation \
                      fonctionnels, ainsi que les systèmes de type avancés. Je \
                      programme en Ocaml depuis le début de mes études, et \
                      j'apprécie beaucoup ce langage. J'ai un peu d'expérience \
                      en Scala ainsi qu'en Rust, et j'ai beaucoup expérimenté \
                      avec les fonctionnalités avancées de C++.\n\
                      J'ai aussi publié un paquet sur Opam, le gestionnaire de \
                      paquets d'Ocaml : "
                 ; f "url"
                     "https://github.com/EmileTrotignon/embedded_ocaml_templates"
                 ; S
                     ".\n\
                      Il contient un réecriveur PPX, ainsi qu'un petit parser \
                      écrit avec Menhir." ]
               ~english:
                 [ S
                     " I really enjoy functionnal programming languages, as \
                      well as advanced type systems. I have been programming \
                      in OCaml since my first year of university, and I am \
                      very passionate about this language. I have some \
                      experience with Scala and Rust, and I had a lot of fun \
                      exploring advanced C++ features.\n\
                      I also published a package on Opam, the Ocaml package \
                      manager : "
                 ; f "url"
                     "https://github.com/EmileTrotignon/embedded_ocaml_templates"
                 ; S
                     ".\n\
                      It includes a PPX rewriter, and a small parser written \
                      with Menhir." ] )
      ; skill (I "Proof assistants and verification") Basic
          ~description:
            (v
               ~french:
                 (atom
                    "J'ai suivi un cours sur l'assistant de preuve Coq, et \
                     l'outil de vérification Why3. Je ne suis pas autonome \
                     avec ces outils, mais j'aimerai beaucoup en apprendre \
                     plus." )
               ~english:
                 (atom
                    "I have taken a course on the Coq proof assistant, and one \
                     on the Why3 verification framework. I am not fluent with \
                     neither of this tools, but I would love to become more \
                     familiar with them." ) )
      ; skill (I "GUIs") Intermediate
          ~description:
            (v
               ~french:
                 (atom
                    "Expérience avec quelques frameworks d'interfaces \
                     graphiques :\n\
                     Qt et Dear ImGUI pour C++, WinForm pour C#, Swing pour \
                     Scala, Tkinter pour Python" )
               ~english:
                 (atom
                    "I have experience with a few frameworks for programming \
                     GUIs :\n\
                     Qt and Dear ImGUI with C++, WinForm with C#, Swing with \
                     Scala, Tkinter with Python." ) )
      ; skill
          (v ~french:"Développement web" ~english:"Web development")
          Intermediate
          ~description:
            (v
               ~french:
                 (atom
                    "Front-end : Bonne connaissance de HTML/CSS. J'ai exercé \
                     cette compétence professionnellement lors de l'été 2018.\n\n\
                     Back-end : Expérience professionnelle de développement \
                     d'une application Node.js ." )
               ~english:
                 (atom
                    "Front-end : Good knowledge of HTML and CSS. One month \
                     experience during the summer of 2018.\n\n\
                     Back-end : Professional experience developing a Node.js \
                     web app." ) )
      ; skill
          (v ~french:"Divers" ~english:"Miscellaneous")
          Strong
          ~description:
            (v
               ~french:
                 (atom
                    "Utilisation d'un système Unix avec la ligne de commande : \
                     manipulation de fichier, Git, SSH.\n\
                     Édition d'image avec GIMP.\n\
                     Rédaction de documents en Latex. " )
               ~english:
                 (atom
                    "Use of a Unix system with the command line : file \
                     manipulation, Git, SSH.\n\
                     Image editing with GIMP and Inkscape.\n\
                     Typesetting with Latex." ) ) ]
    ~phonenumber:(I "+33 7 82 89 83 58") ~email:(I "emile.trotignon@gmail.com")
    ~website:(I "")
    ~birthdate:(v ~french:"30 juillet 1999" ~english:"July 30th, 1999")
