(lang dune 3.10)
(using directory-targets 0.1)
(package
 (name website_of_ocaml)
 (synopsis
  "Generate my personnal website from OCaml code and markdown files")
 (description
  "Generate my personnal website from OCaml code and markdown files")
 (depends
  (ocaml
   (>= 5.1))
  (embedded_ocaml_templates
   (>= 0.8))
  (ppx_deriving
   (>= 5.2.1))
  (bos
   (>= 0.2.1))
  (omd
   (>= 2.0.0~alpha4))
  dune
  (tyxml
   (>= 5.1))))
