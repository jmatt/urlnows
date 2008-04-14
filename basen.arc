;version 0.1

;;;;;;;;;;;;;
;;;;basen;;;;
;;;;;;;;;;;;;

(def char-int (c) (coerce c 'int))

(def int-char (i) (coerce i 'char))

;
;list of base-n alphabet
(= base-ints (flat (join ;could add to base here. for example: (list (char-int #\+) (char-int #\-)) 
			 (map range 
			      (map char-int (list #\0 #\a #\A)) 
			      (map char-int (list #\9 #\z #\Z))))))

(= base-chars (map int-char base-ints))

(= base (len base-ints))

(def ten2base-helper (b) (let r (mod b base)
		    (if (is (- b r) 0) 
			(base-chars r)
			(cons (ten2base (/ (- b r) base)) (base-chars r)))))

;
;produces a list of base b characters representing the number n
(def ten2base (b) (flat (ten2base-helper b)))

;
;returns the position of character b in base-chars list.
(def basepos (b) (pos (fn (_) (is _ b)) base-chars))

;
;returns the list of positions of characters b in base-chars list.
(def ten2base-values (_) (map basepos (ten2base _)))

;
;returns the base-10 number represented by b in base.
;b - base number that needs to be converted.
(def base2ten (b) (base2ten-helper (rev b) 0 base))

;
;string to list of chars
(def s-to-l (_) (w/instring ins _ (n-of (len _) (readc ins))))

;
;returns the string representation of (base2ten b)
(def base2ten-string (b) (coerce (base2ten (s-to-l b)) 'string))

;
;returns the base-10 number represented by b in base.
;p - exponent used to do calculation
;base-n - the base that is being converted to. Must be less than variable base
(def base2ten-helper (b p base-n)
  (if (is (cdr b) nil)
      (* (expt base-n p) (basepos (car b)))
      (+ (base2ten-helper (cdr b) (+ p 1) base-n) (* (expt base-n p) (basepos (car b))))))

;
;return string representation in base of integer i. 
(def ten2base-string (i) (reduce + (map [coerce _ 'string] (ten2base i))))
