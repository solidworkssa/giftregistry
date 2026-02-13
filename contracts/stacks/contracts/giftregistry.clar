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

