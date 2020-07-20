open Resume_lib
open Multi_string

let emile : Resume.t =
    {
      firstname = I "Émile";
      lastname = I "Trotignon";
      formations =
        [
          {
            school = I "École Normale Supérieure Paris-Saclay";
            diploma =
              V { french = "L3 Informatique"; english = "Computer Science BS" };
            description = None;
            date_start = Some (I "2019");
            date_end = Some (I "2020");
            location = None;
            result = None;
          };
          {
            school = I "Université Lyon 1 Claude-Bernard";
            diploma =
              V
                {
                  french = "L2 Informatique - mathématiques";
                  english = "Second year of Computer Science and Mathematics BS";
                };
            description = None;
            date_start = Some (I "2018");
            date_end = Some (I "2019");
            location = None;
            result = None;
          };
          {
            school =
              V
                {
                  french =
                    "Lycée Jean Perrin (Option Informatique au Lycée du Parc)";
                  english = "Jean-Perrin preparatory school";
                };
            diploma =
              V
                {
                  french = "CPGE MPSI";
                  english = "First year of engineering BS";
                };
            description = None;
            date_start = Some (I "2017");
            date_end = Some (I "2018");
            location = None;
            result = None;
          };
          {
            school = I "Lycée La Trinité";
            diploma =
              V
                {
                  french = "Baccalauréat scientifique";
                  english = "High school diploma with science focus";
                };
            description = None;
            date_start = Some (I "2016");
            date_end = Some (I "2017");
            location = Some (I "Lyon");
            result =
              Some
                (V { french = "Mention Très Bien"; english = "with honours" });
          };
        ];
      experiences =
        [
          {
            title = I "ICPC SWERC 2019-2020";
            company = I "";
            date = V { french = "Janvier 2020"; english = "January 2020" };
            location = Some (I "Télécom Paris");
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Compétition de programmation/algorithmique universitaire. 
                             Participation au sein d'une équipe de trois.
                             Classement de mon équipe : 37 sur 95 équipes répresentant des universités de plusieurs pays européens|};
                       ];
                     english =
                       [
                         S
                           {|University programmation/algorithms competition.
                             Participation in teams of three student.
                             Ranked 37 on 95 teams representing universities from multiple european countries.|};
                       ];
                   });
          };
          {
            title =
              V
                {
                  french = "Développeur stagiaire C#";
                  english = "Intern C# developper";
                };
            company = I "Eternix Ldt.";
            date = V { french = "Été 2019"; english = "Summer 2019" };
            location = Some (I "Tel Aviv, Israel");
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Stage de 2 mois. Écriture de shaders HLSL, découverte de DirectX, développement Windows Form, expérience avec OpenCV.
                             Expérience extrêmement enrichissante dans une entreprise étrangère|};
                       ];
                     english =
                       [
                         S
                           {|Two month internship. HSLS shaders, introduction to DirectX and OpenCV, Windows Form developpement.
                             Greatly rewarding experience abroad.|};
                       ];
                   });
          };
        ];
      languages =
        [
          {
            name = V { french = "Anglais"; english = "English" };
            strength = Strong;
          };
          {
            name = V { french = "Français"; english = "French" };
            strength = VeryStrong;
          };
        ];
      skills =
        [
          {
            name = I "C++";
            strength = VeryStrong;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Cours de C++ suivi \`a l'université. Utilisation du C++ pour des projets personnels utilisant des concept plus avancés, ainsi que pour de la programmation compétitive.
	
	                Je sais aussi programmer en C ANSI.|};
                       ];
                     english =
                       [
                         S
                           {|I followed a C++ course at university and I also used C++ both for competitive programmation and personnal projects. 
                           
                           I also know C ANSI.|};
                       ];
                   });
          };
          {
            name = I "Python";
            strength = Intermediate;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Programmation en Python comme loisir depuis 2013. J'ai également suivi des cours de Python lors de mon année de terminale (spécialité ISN), ainsi que lors de mon année de CPGE .
	
	                       J'ai plusieurs projets en python disponibles sur ma page GitHub :

                         |};
                         F
                           ( "url",
                             "https://github.com/EmileTrotignon?tab=repositories&q=&type=&language=python"
                           );
                       ];
                     english =
                       [
                         S
                           {|I started Python as a hobby in 2013. I also followed courses on scientific computing.
                       
                       I have a few Python projects available on my GitHub page : 

                       |};
                         F
                           ( "url",
                             "https://github.com/EmileTrotignon?tab=repositories&q=&type=&language=python"
                           );
                       ];
                   });
          };
          {
            name = I "C#";
            strength = VeryStrong;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Bonne connaissance de C# : expérience professionelle de ce langage de 2 mois.

                         Deux projets d'apprentissage réalisés dans le cadre de ce stage :

                         |};
                         F
                           ( "url",
                             "https://github.com/EmileTrotignon/InterpolationShaders"
                           );
                         S
                           "\n\n\
                            Ce projet affiche une image avec DirectX et permet \
                            d'utiliser l'interpolation de Lanczos sur \
                            celle-ci.\n\n";
                         F ("url", "https://github.com/EmileTrotignon/CSGoban");
                         S
                           "\n\nPetite application permettant de jouer au jeu de \
                            Go.";
                       ];
                     english =
                       [
                         S
                           {|Good knowledge of C# : professional experience of 2 month.

                         Two learning projects made in this language :
                         |};
                         F
                           ( "url",
                             "https://github.com/EmileTrotignon/InterpolationShaders"
                           );
                         S
                           "\n\n\
                            This project displays a simple texture with \
                            DirectX and implement Lanczos interpolation in \
                            pixel shaders.\n\n";
                         F ("url", "https://github.com/EmileTrotignon/CSGoban");
                         S
                           "\n\nSmall WinForm application allowing to play the \
                            game of Go.";
                       ];
                   });
          };
          {
            name = I "OCaml";
            strength = Strong;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Cours de OCaml suivi dans le cadre de l'option informatique en CPGE : ce cours est orienté informatique théorique.
                
                         Lors de mes études à l'ENS, j'ai écris en OCaml un compilateur pour un sous-ensemble du langage C :

                         |};
                         F ("url", "https://github.com/EmileTrotignon/mcc");
                       ];
                     english =
                       [
                         S
                           {|I had an OCaml course in my first year. 
                
                         In my third year I programmed a compiler for a subset of the C language :

                         |};
                         F ("url", "https://github.com/EmileTrotignon/mcc");
                       ];
                   });
          };
          {
            name =
              V { french = "Développement web"; english = "Web development" };
            strength = Strong;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Front-end : Bonne connaissance de HTML/CSS : j'ai exercé cette compétence professionnellement lors de l'été 2018.
	
	                       Back-end : Experience professionnelle de developpement d'une application Node.js .|};
                       ];
                     english =
                       [
                         S
                           {|Front-end : good knowledge of HTML and CSS : one month experience during summer 2018

                         Back-end : Professional experience developping a Node.js web app|};
                       ];
                   });
          };
          {
            name = I "Unix";
            strength = Intermediate;
            description =
              Some
                (V
                   {
                     french =
                       [
                         S
                           {|Je sais utiliser un système Unix avec la ligne de commande : manipulation de fichier, Git, SSH |};
                       ];
                     english =
                       [
                         S
                           {|I know how to use a Unix system with the command line : file manipulation, Git, SSH|};
                       ];
                   });
          };
        ];
      phonenumber = I "+33 7 82 89 83 58";
      email = I "emile.trotignon@gmail.com";
      website = I "";
      birthdate = V { french = "30 juillet 1999"; english = "30 of July 1999" };
    }


