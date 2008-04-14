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

(= urlnows-site* "localhost:8080")
(= rootdir* "/Users/jmatt/dev/urlnows/urlnows_public_html/")
(= urlnows-title* "urlNOWs")

;(defop

(mac urlpost body
  `(center
	(gentag img src "urlnows4.png")
	(br 2)
       (widtable 600
		 (tag b (link urlnows-title* "url"))
		 (br 2)
		 ,@body
		 (br 2)
		 (w/bars (link "url") (link "see urls" "urls")))))
  ;(pr (p 'text)))

(defop url req
       	   (center
		(gentag img src "urlnows4.png")
	  	(aform (fn (req) (urlpost (map [pr _]
			   	 	  (br 2) 
				    	  (underlink (shortlink (+ "http://" urlnows-site* "/" (cadr (get-id (arg req "urltext")))))))))
		 (br2)
		 (textarea "urltext" 1 48 (pr "http://"))
		 (but "url" "submit"))))
       
(def usv ((o port 8080))
  (open-db)
  (asv port))

;redefine respond so it works properly with our ninja operators
(def respond (str op args cooks ip (o type))
  (w/stdout str
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
	 (if (let load-url (get-url (coerce op 'string))
	       (if (isnt load-url nil)
		   ; get  (respond o op args cooks ip type)
		   (do (prn rdheader*) (prn "Location: " (car (cdr (car load-url)))) (prn))
		   ;(do (prn rdheader*) (prn "Location: " (cdr (car load-url))) (prn))
		     ;(prn rdheader*) (prn "Location: " (o str (cdr (car load-url)))) (prn))
		   ; (prn "str " str) (prn "req " req) (prn "ip" ip) (prn load-url)) 
		   ;(prn rdheader*)
		   ;(prn "Location: " it (cdr (car load-url)) req)
		   ;(prn))
		   (if (is type 'head)
		       (do (prn (err-header 404)) (prn))
		       (respond-err str 404 unknown-msg*))))))))
