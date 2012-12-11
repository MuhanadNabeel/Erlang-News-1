{application, ernews_app,
 [{vsn, "1.0.0"},
  {modules, [ernews_app, ernews_db, ernews_defuns, ernews_html, ernews_htmlfuns,
   ernews_linkserv, ernews_rssagnet, ernews_rssread, ernews_supervisor,     
   mochiutf8, mochiweb_charref, mochiweb_html, mysql_auth, mysql_conn, mysql_recv, mysql]},
  {registered, [ernews_app]},
  {mod, {ernews_app, []}}
 ]}.