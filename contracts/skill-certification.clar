;; Constants and Error Codes
(define-constant contract-owner tx-sender)
(define-constant err-admin-only (err u200))
(define-constant err-already-certified (err u201))
(define-constant err-certification-not-found (err u202))
(define-constant err-invalid-credential (err u203))
(define-constant err-insufficient-fee (err u204))
(define-constant err-certification-revoked (err u205))
(define-constant err-invalid-skill (err u206))
(define-constant err-invalid-id (err u207))

;; Data Variables
(define-data-var verification-fee uint u50) ;; Fee in microstacks for verification services
(define-data-var certification-expiration uint u365) ;; Duration in days before certification expires
(define-data-var cert-count uint u0) ;; Total number of certifications issued
(define-data-var revoked-certifications uint u0) ;; Count of revoked certifications

;; Data Maps
(define-map certificates 
    {id: uint} 
    {
        holder: principal, 
        skill: (string-ascii 50), 
        issued-on: uint, 
        expires-on: uint, 
        is-active: bool
    }
)

(define-map holder-certifications 
    principal 
    {
        certification-id: uint
    }
)

;; Private Helper Functions

;; Validate skill string
(define-private (validate-skill (skill (string-ascii 50)))
    (let ((skill-length (len skill)))
        (and (>= skill-length u1) (<= skill-length u50))))

;; Validate certification ID
(define-private (validate-cert-id (cert-id uint))
    (and (> cert-id u0) (<= cert-id (var-get cert-count))))

;; Calculate expiration date
(define-private (calculate-expiration (issue-date uint))
    (+ issue-date (var-get certification-expiration)))

;; Issue Certification ID
(define-private (new-cert-id)
    (let ((current-id (var-get cert-count)))
        (var-set cert-count (+ current-id u1))
        current-id))

;; Fix a bug in certification holder mapping logic
(define-private (fix-holder-mapping-bug (holder principal))
    (begin
        (match (map-get? holder-certifications holder)
            cert-data (ok cert-data)
            (err err-certification-not-found))))

;; Optimize contract function: Refactor fee calculation to a separate function
;; Centralizes the fee deduction logic in a reusable function for future scalability.
(define-private (transfer-fee (amount uint))
    (begin
        (try! (stx-transfer? amount tx-sender contract-owner))
        (ok true)))

;; Public Functions

;; Update verification fee (admin only)
(define-public (update-verification-fee (new-fee uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-admin-only)
        (asserts! (> new-fee u0) err-invalid-credential)
        (ok (var-set verification-fee new-fee))))
