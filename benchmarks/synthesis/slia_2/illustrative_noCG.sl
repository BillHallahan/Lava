(set-logic SLIA)

(synth-fun f ((name String)) Int
     ((Start Int (ntInt))
      (ntString String (name
                       (str.++ ntString ntString)
                       (str.replace ntString ntString ntString)
                       (str.at ntString ntInt)
                       (int.to.str ntInt)
                       (str.substr ntString ntInt ntInt)))
      (ntInt Int (0 1
                  (+ ntInt ntInt)
                  (- ntInt ntInt)
                  (str.len ntString)
                  (str.to.int ntString)
                  (str.indexof ntString ntString ntInt)))
      (ntBool Bool (true false
                    (str.prefixof ntString ntString)
                    (str.suffixof ntString ntString)
                    (str.contains ntString ntString)))))


(declare-var name String)
 
(constraint (= (f "hello") 16))
(constraint (= (f "livs") 9))
 
(check-synth)

