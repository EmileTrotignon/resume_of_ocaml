open Core
open Resume_lib

let () =
  Out_channel.write_all "fr.tex"
    ~data:(Resume_builder.to_latex Instance.emile Multi_string.French) ;
  Out_channel.write_all "en.tex"
    ~data:(Resume_builder.to_latex Instance.emile Multi_string.English) ;
  Out_channel.write_all "resume.html"
    ~data:
      ( Html.to_string
      @@ Html.resume
           (Resume_builder.to_html Instance.emile Multi_string.English) ) ;
  Out_channel.write_all "index.html"
    ~data:
      ( Html.to_string
      @@ Html.index (Resume_builder.to_html Instance.emile Multi_string.English)
      ) ;
  Out_channel.write_all "software.html"
    ~data:
      ( Html.to_string
      @@ Html.software
           (Resume_builder.to_html Instance.emile Multi_string.English) ) ;
  Out_channel.write_all "404.html"
    ~data:
      ( Html.to_string
      @@ Html.page_404
           (Resume_builder.to_html Instance.emile Multi_string.English) )
