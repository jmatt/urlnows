;version 0.1

;initialization code for urlno.ws
(prn "Creating database urlnows...")

(= urlnows-db (db+ "urlnows"))

(prn "Creating table url...")

(sql urlnows-db "CREATE TABLE url (url_id integer primary key, uri varchar(2048))")

(prn "Database initialization complete.")
