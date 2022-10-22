
;; roman-counter
;; <A counter which uses Roman Numerals. The counter can be increased or decreased. 
;; Since Ancient Romans did not use 0 and negative numbers the counter only counts numbers greater than 0.>

;; constants
(define-constant ZERO-OR-NEGATIV-NOT-ALLOWED (err "Ancient Romans did not use 0 and negative numbers"))

(define-constant romanNumerals1 { number: 1000 , sign: "M"})
(define-constant romanNumerals2 { number: 900 , sign: "CM"})
(define-constant romanNumerals3 { number: 500 , sign: "D"})
(define-constant romanNumerals4 { number: 400 , sign: "CD"})
(define-constant romanNumerals5 { number: 100 , sign: "C"})
(define-constant romanNumerals6 { number: 90 , sign: "XC"})
(define-constant romanNumerals7 { number: 50 , sign: "L"})
(define-constant romanNumerals8 { number: 40 , sign: "XL"})
(define-constant romanNumerals9 { number: 20 , sign: "XX"})
(define-constant romanNumerals10 { number: 10 , sign: "X"})
(define-constant romanNumerals11 { number: 9 , sign: "IX"})
(define-constant romanNumerals12 { number: 5 , sign: "V"})
(define-constant romanNumerals13 { number: 4 , sign: "IV"})
(define-constant romanNumerals14 { number: 3 , sign: "III"})
(define-constant romanNumerals15 { number: 2 , sign: "II"})
(define-constant romanNumerals16 { number: 1 , sign: "I"})




;; variables
(define-data-var counter int 0)
(define-data-var romanCounter (string-ascii 32) "")
(define-data-var count int 0)


;; read-only funtion to get the current counter value
(define-read-only (get-counter)
    (var-get counter)
)

;; read-only funtion to get the roman numeral of the current counter value
(define-read-only (get-romanCounter)
    (var-get romanCounter)
)


;; punblic function to increment the counter value
(define-public (increment)
    (begin 
        (var-set counter (+ (var-get counter) 1))
        (try! (to-roman (var-get counter)))
        (ok { Counter: (var-get counter), RomanCounter: (var-get romanCounter) })
    )
)

;; punblic function to decrement the counter value
(define-public (decrement) 
    (begin
        (var-set counter (- (var-get counter) 1))
        (asserts! (> (var-get counter) 0) ZERO-OR-NEGATIV-NOT-ALLOWED)
        (try! (to-roman (var-get counter)))
        (ok { Counter: (var-get counter), RomanCounter: (var-get romanCounter) })
    )
)

;; private function containing the conversion steps to roman numerals
(define-private (conversionSteps (step {number: int , sign: (string-ascii 3)}))   
    (if (>= (var-get count) (get number step)) 
        (begin    
            (var-set romanCounter (unwrap-panic (as-max-len? (concat (var-get romanCounter) (get sign step)) u32)))
            (var-set count (- (var-get count) (get number step)))   
        ) 
    true
    )    
)

;; private function to perform the conversion to roman numerals
(define-private (to-roman (number int))
    (begin
        (asserts! (> number 0) ZERO-OR-NEGATIV-NOT-ALLOWED)
        (var-set romanCounter "")
        (var-set count number)
        (map conversionSteps (list romanNumerals1 romanNumerals2 romanNumerals3 romanNumerals4
                                    romanNumerals5 romanNumerals6 romanNumerals7 romanNumerals8
                                    romanNumerals9 romanNumerals10 romanNumerals11 romanNumerals12 
                                    romanNumerals13 romanNumerals14 romanNumerals15 romanNumerals16
                            )
        )      
        (ok true)
    )
)

