open Core
open Resume_lib

let () =
  Out_channel.write_all "fr.tex"
    ~data:(Resume_builder.to_latex Instance.emile Multi_string.French) ;
  Out_channel.write_all "en.tex"
    ~data:(Resume_builder.to_latex Instance.emile Multi_string.English) ;
  Out_channel.write_all "resume.html"
    ~data:
      (Templates.Site.resume
         (Resume_builder.to_html Instance.emile Multi_string.English) ) ;
  Out_channel.write_all "index.html"
    ~data:
      (Templates.Site.index
         (Resume_builder.to_html Instance.emile Multi_string.English) ) ;
  Out_channel.write_all "404.html"
    ~data:
      (Templates.Site.page_404
         (Resume_builder.to_html Instance.emile Multi_string.English) )
  