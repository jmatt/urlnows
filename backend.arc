(require "/Users/jmatt/dev/urlnows/basen.arc")

;;given the filename, this will save the ids and urls hash tables to that file.
;;saved in order: (ids urls)
(def save-db (filename)
  (let dbx (w/outfile outf filename (write-table ids outf) (write-table urls outf)))
  t)

;;give the filename, this will load the ids and urls hash tables to that file.
;;order expected: (ids urls)
(def load-db (filename)
  (let dbx (load-tables filename)
    (if dbx 
      (do
	(= ids (car dbx))
	(= urls (car (cdr dbx))))
      (do
	(= ids (table))
	(= urls (table))))))

;;get the proper url with the proper protocol.
;;valid cases: '\\' '<10 digits>://' otherwise prepend 'http://'
(def get-actual-url (url) 
  (let protocolpos (posmatch "://" url)
  (if (or 
	(and protocolpos 
	     (< protocolpos 12) 
	     (> (len url) (+ 3 protocolpos))) 
	(litmatch "\\" url))
      url
      (+ "http://" url))))

;;either inserts url or returns a list containing the id and whether it is new.
(def insert-url (url)
  (let actualurl (get-actual-url url)
  (let existing-id (urls actualurl)
    (if existing-id
        (list existing-id nil)
        (let new-basen-id (ten2base-string (get-new-id))
          (fill-table ids (list new-basen-id actualurl))
          (fill-table urls (list actualurl new-basen-id))
          (list new-basen-id t))))))

;;redefine to work with basen
;;gets the "current-id" variable
(def get-new-id ()
  (= current-id (increment current-id)))

;;increment i by val
(def increment (i (o val 1))
  (+ i val))

;;init the current-id variable
(def init-current-id ()
  (let cid  (car (mergesort > (keys ids)))
    (if cid 
      (= current-id (coerce cid 'int))
      (= current-id 0))))

;;given the basen id this will return the url string.
(def get-url (id)
  (ids id))

;;init the files and backend.
(def init-urlnows-backend ()
  ;TODO: make sure file exists before load. - if not create
  (load-db "/Users/jmatt/dev/urlnows/urlnows.arc")
  (init-current-id)
  (thread (auto-save)))

(def auto-save ()
  (sleep 10)
  (save-db "/Users/jmatt/dev/urlnows/urlnows.arc")
  (auto-save))

