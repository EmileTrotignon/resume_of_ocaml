(*
(async () => {
  const response = await fetch('https://api.github.com/repos/:user/:repo/contents/');
  const data = await response.json();
  let htmlString = '<ul>';
  
  for (let file of data) {
    htmlString += `<li><a href="${file.path}">${file.name}</a></li>`;
  }

  htmlString += '</ul>';
  document.getElementsByTagName('body')[0].innerHTML = htmlString;
})()   
*)

open Brr
open Fut.Syntax

let don't_wait_for f = 
  Fut.await f (fun () -> ())

let ( .%{} ) obj prop = Jv.get obj prop 

let run () =
  let+ result = 
  let open Fut.Result_syntax in
  let open Brr_io.Fetch in
  let* response = 
    Brr_io.Fetch.(
      request 
        (Request.v ~init:(Request.init ())
        (Jstr.of_string "https://api.github.com/repos/EmileTrotignon/blog/contents/")))
  in
  let+ data = response |> Response.as_body |> Body.json in
  let urls = Jv.(to_array (fun elt -> elt.%{"git_url"} |> to_string) data) in
  let contents =
    Array.map (fun md_url ->
      Brr_io.Fetch.(
      request 
        (Request.v ~init:(Request.init ())
        (Jstr.of_string md_url)))
      
      ) urls in
  Console.log [urls]
in
match result with
| Error _e -> ()
| Ok () -> ()

let () = 
  don't_wait_for (run ())