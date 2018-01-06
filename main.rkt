#lang braidbot/insta

(require braidbot/util)

(define (rot13-ch ch)
  (let ([c (char->integer ch)])
    (cond
     [(<= (char->integer #\A) c (char->integer #\Z))
      (-> c
          (- (char->integer #\A))
          (+ 13)
          (modulo 26)
          (+ (char->integer #\A))
          integer->char)]
     [(<= (char->integer #\a) c (char->integer #\z))
      (-> c
          (- (char->integer #\a))
          (+ 13)
          (modulo 26)
          (+ (char->integer #\a))
          integer->char)]
     [else ch])))

(define (rot13 txt)
  (->> txt
      string->list
      (map rot13-ch)
      list->string))

(define bot-id (or (getenv "BOT_ID") "5a5021d0-c517-4e27-ac1e-12a7b3d7a6c6"))
(define bot-token (or (getenv "BOT_TOKEN") "91nPY7IFP5W68SCk3p0zoCCSCKeduLHnIJfZG2ou"))
(define braid-url (or (getenv "BRAID_URL") "http://localhost:5557"))

(listen-port 9988)

(define (act-on-message msg)
  (reply-to msg (-> msg
                    (hash-ref '#:content)
                    (string-replace "/rot13" "" #:all? #f)
                    rot13)
            #:bot-id bot-id
            #:bot-token bot-token
            #:braid-url braid-url))
