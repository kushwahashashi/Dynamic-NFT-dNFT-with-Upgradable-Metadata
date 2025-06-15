(define-map token-owners uint principal)
(define-map token-metadata uint (string-ascii 200))
(define-data-var token-id-counter uint u0)

;; Mint a new dNFT
(define-public (mint (metadata (string-ascii 200)))
  (let ((new-id (var-get token-id-counter)))
    (begin
      (map-set token-owners new-id tx-sender)
      (map-set token-metadata new-id metadata)
      (var-set token-id-counter (+ new-id u1))
      (ok new-id))))

;; Update metadata (only owner can update)
(define-public (update-metadata (id uint) (new-meta (string-ascii 200)))
  (let ((owner (map-get? token-owners id)))
    (match owner some-owner
      (begin
        (asserts! (is-eq tx-sender some-owner) (err u100))
        (map-set token-metadata id new-meta)
        (ok true))
      (err u101))))

;; Read metadata
(define-read-only (get-metadata (id uint))
  (ok (map-get? token-metadata id)))
