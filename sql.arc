;version 0.1

;;;;;;;;;;
;;;;DB;;;;
;;;;;;;;;;

(= dbnil 'nil)

(def db+ (name (o host "localhost") (o port 54650))
 (let (i o) (connect-socket host port)
   (db> o name)
   (if (db< i) (list i o))))

(def sql ((i o) q)
 (db> o q)
 (if (db< i) (readall i 200)))

(def db- (db)
 (map close db))

(def db> (o s)
 (write s o)
 (writec #\return o)
 (writec #\newline o)
 (flush-socket o))

(def db< (i)
 (= dbnil (read i))
 (iso dbnil 200))


;define the test database variable
(= urlnows-db nil)

;open the database
(def open-db () (= urlnows-db (db+ "urlnows")))

;close the databse
(def close-db () (do (db- urlnows-db) (= urlnows-db nil)))

;select * from table
;sw - nil will not use a where clause. Otherwise sw is the where clause string
(def select (sw) (if (is (type sw) 'string) 
		     (sql urlnows-db (+ "SELECT * FROM url WHERE " sw ";"))
		     (sql urlnows-db "SELECT * FROM url;")))


(def find-uri (t) (let v (select (+ "uri = '" t "'")) 
			 (if (is v nil)
			     nil
			     (car v))))

(def insert (u) (sql urlnows-db (+ "INSERT INTO url (uri) VALUES ('" u "'); SELECT last_insert_rowid();")))

(def get-id (ws) (let r (find-uri ws)
		   (if r
		       (let i (coerce (car r) 'int) 
			 (list 
			   i 
			   (ten2base-string i) 
			   ws))
		       (let ins (insert ws) 
			 (list (coerce (caar ins) 'int) 
			       (ten2base-string (coerce (caar ins) 'int)) 
			       ws)))))

(def get-url (base) (select (+ "url_id = " (base2ten-string base))))

