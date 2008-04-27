;;;;;;;;;;;
;;;;Web;;;;
;;;;;;;;;;;
;(= urlnowsop-names* nil)

;(mac opexpand (definer name params . body)
;  (w/uniq gr
;    `(,definer ,name ,gr (params . body))))

;(mac urlnowsop args
;  `(do (pushnew ',(car args) urlnowsop-names*)
;       (opexpand defop ,@args)))

;(urlnowsop urlform ()
;	   (vars-form (urlnows-fields) ))

(= urlnows-site* "localhost:8008")
(= rootdir* "/Users/jmatt/dev/urlnows/urlnows_public_html/")
(= urlnows-title* "urlNOWs")

;(defop

(mac urlpost body
  `(center
     (tag (title) (pr "URLNOWS"))
     (tag (head) (tag (link rel "shortcut icon" href "/u.ico")))
     ;    (tag (a) (href "url") 
     (gentag img src "urlnows5.png")
     ;)
     (br 2)
     ;(widtable 600
     ;(tag b (link urlnows-title* "url"))
     (br 2)
     ,@body
     (br 2)
     ;(w/bars (link "Preview") (link "Explanation") (link "About")))))
     ;(pr (p 'text)))
     (pr "© urlno.ws")))

(mac urlcss (req .body)
  `(center
		(gentag img src "urlnows5.png")
		(tag (title) (pr "URLNOWS"))
		(tag (head) (tag (link rel "shortcut icon" href "/u.ico")))
		,@body
		;footer
))


(defop url req
       	   (center
		(gentag img src "urlnows5.png")
		(tag (title) (pr "URLNOWS"))
		(tag (head) (tag (link rel "shortcut icon" href "/u.ico")))
	  	(aform (fn (req) (urlpost (map [pr _]
			   	 	  (br 2) 
				    	  (underlink (shortlink (+ "http://" urlnows-site* "/" (car (insert-url (arg req "urltext")))))))))
		 (br2)
		 (pr "urlnows   ")
		 (input "urltext" "http://" 64)
		 (but "reduce" "urlsubmit")
		 (br 2)
		 (pr "© urlno.ws"))))
       
(def usv ((o port 8080))
  (init-urlnows-backend)
  (thread (asv port)))

;redefine respond so it works properly with our ninja operators
(def respond (str op args cooks ip (o type))
  (w/stdout str
;(let outf (outfile "/Users/jmatt/dev/urlnows/usv.log" 'append) (w/stdout outf (w/bars (pr str) (pr op) (pr args) (pr cooks) (pr ip) (prn))))
    (aif (srvops* op)
          (let req (inst 'request 'args args 'cooks cooks 'ip ip)
            (if (redirector* op)
                (do (prn rdheader*)
                    (prn "Location: " (it str req))
                    (prn))
                (do (prn (header))
                    (if (is type 'head) (prn) (it str req)))))
         (file-exists-in-root (string op))
          (if (is type 'head)
            (do (prn (header (filemime it))) (prn))
            (respond-file str it))
	 (if (withs (p-op (parseops op) 
		     basen-id (car p-op)
		     rest (cadr p-op)
		     load-url (if (or rest args)
				  (+ (+ (get-url (coerce basen-id 'string)) rest) (eval `(let req (obj args ',args) (reassemble-args req))))
				  (get-url (coerce basen-id 'string))))
	       (if (isnt load-url nil)
		   ; get  (respond o op args cooks ip type)
		   (do (prn rdheader*) (prn "Location: " load-url) (prn))
		       ;(let outf (outfile "/Users/jmatt/dev/urlnows/usv+.log" 'append) (w/stdout outf (w/bars (pr str) (pr op) (pr args) (pr cooks) (pr ip) (prn) (pr p-op) (pr basen-id) (pr rest) (pr load-url)))))

		   ;(do (prn rdheader*) (prn "Location: " (cdr (car load-url))) (prn))
		     ;(prn rdheader*) (prn "Location: " (o str (cdr (car load-url)))) (prn))
		   ; (prn "str " str) (prn "req " req) (prn "ip" ip) (prn load-url)) 
		   ;(prn rdheader*)
		   ;(prn "Location: " it (cdr (car load-url)) req)
		   ;(prn))
		   (if (is type 'head)
		       (do (prn (err-header 404)) (prn))
		       (respond-err str 404 unknown-msg*))))))))


(def parseops (ops) 
  (let s (coerce ops 'string)
  (map (fn (l) (coerce l 'string))
       (let pos (posmatch (fn (_) (no (alphadig _))) s)
       (if pos 
	   (split (coerce s 'cons) pos) 
	   (list s))))))