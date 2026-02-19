;; ────────────────────────────────────────
;; GiftRegistry v1.0.0
;; Author: solidworkssa
;; License: MIT
;; ────────────────────────────────────────

(define-constant VERSION "1.0.0")

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-INPUT (err u422))

;; GiftRegistry Clarity Contract
;; On-chain gift registry and contribution tracking.


(define-map items
    uint
    {
        name: (string-utf8 64),
        cost: uint,
        funded: uint
    }
)
(define-data-var item-nonce uint u0)

(define-public (add-item (name (string-utf8 64)) (cost uint))
    (let ((id (var-get item-nonce)))
        (map-set items id {name: name, cost: cost, funded: u0})
        (var-set item-nonce (+ id u1))
        (ok id)
    )
)

(define-public (contribute (id uint) (amount uint))
    (let ((item (unwrap! (map-get? items id) (err u404))))
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set items id (merge item {funded: (+ (get funded item) amount)}))
        (ok true)
    )
)

