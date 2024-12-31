# Clarity Certification Service Smart Contract

This is a Clarity smart contract that manages the certification issuance, verification, and revocation process, including associated fee handling and skill validation. The contract allows an admin to manage various parameters, such as certification fee and expiration period, and allows holders to issue, update, and verify certifications for specific skills.

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Contract Architecture](#contract-architecture)
4. [Functions](#functions)
    1. [Public Functions](#public-functions)
    2. [Read-Only Functions](#read-only-functions)
    3. [Private Helper Functions](#private-helper-functions)
5. [Constants & Error Codes](#constants--error-codes)
6. [Data Structures](#data-structures)
7. [Admin Operations](#admin-operations)
8. [Security](#security)
9. [Unit Testing](#unit-testing)
10. [UI Integration](#ui-integration)

## Overview

This smart contract provides a set of functionalities to manage a certification system for a specified skill. Key features include issuing certifications, verifying their validity with a fee, revoking certifications, and allowing skill updates. The contract enforces administrative control over certain actions and offers transparency on certification details.

## Features

- **Certification Issuance**: Allows the issuance of new certifications to individuals, assigning them a unique ID and expiration date.
- **Verification of Certification**: Certification verification requires a small fee. The system checks whether the certification is valid and not revoked.
- **Revocation of Certification**: Admins can revoke certifications, which will disable the certification and prevent further verification.
- **Skill Management**: Admins can add and update skills that are associated with certifications.
- **Fee Management**: Admins can set and update the verification fee for certifications.
- **Expiration Management**: Admins can set the certification expiration period, after which certifications will no longer be valid.

## Contract Architecture

The contract is structured around the following primary components:

1. **Constants**: Define fixed values such as error codes and the contract owner.
2. **Data Variables**: Store information such as the verification fee, certification expiration period, total certifications issued, and revoked certifications count.
3. **Maps**: Store data mappings for certificates and holder certifications.
4. **Public Functions**: Exposed functions that allow users and admins to interact with the contract.
5. **Private Functions**: Internal helper functions for validation and data manipulation.

## Functions

### Public Functions

These functions are accessible to anyone, including the contract owner and certification holders:

1. **update-verification-fee**: Updates the fee for verifying certifications (admin only).
2. **set-certification-expiration**: Sets the expiration period for certifications (admin only).
3. **issue-certification**: Issues a new certification to a holder for a specified skill.
4. **revoke-certification**: Revokes a previously issued certification.
5. **verify-certification**: Verifies the authenticity of a certification (requires payment of the verification fee).
6. **check-certification**: Checks the status of a certification (whether it is active or revoked).
7. **get-holder-cert-id**: Retrieves the certification ID of a holder.
8. **get-verification-fee**: Gets the current verification fee.
9. **get-certification-expiration**: Retrieves the expiration period for certifications.
10. **get-total-certifications**: Retrieves the total number of certifications issued.
11. **get-revoked-certifications**: Retrieves the total number of revoked certifications.
12. **reset-certifications-count**: Resets the total certifications count (admin only).
13. **check-cert-validity**: Allows users to check if their certification is still valid.
14. **get-revocation-history**: Displays a history of revoked certifications.
15. **get-revoked-certifications-list**: Allows admins to view all revoked certifications.
16. **update-skill**: Allows a certification holder to update their skill on an existing certification.

### Read-Only Functions

These functions provide data without requiring any changes:

1. **check-certification-status**: Returns the certification's current status (active or revoked).
2. **get-revoked-certifications**: Returns the count of revoked certifications.

### Private Helper Functions

These functions assist with internal contract logic:

1. **validate-skill**: Validates that the skill string is within a valid length range.
2. **validate-cert-id**: Validates the provided certification ID.
3. **calculate-expiration**: Calculates the expiration date for a certification based on the issue date.
4. **new-cert-id**: Generates a new unique certification ID.

## Constants & Error Codes

The contract includes several constants and error codes to ensure proper error handling:

- **contract-owner**: The address of the contract owner.
- **err-admin-only**: Error thrown when a non-admin user attempts an admin function.
- **err-already-certified**: Error thrown if a holder is already certified.
- **err-certification-not-found**: Error thrown if a certification is not found.
- **err-invalid-credential**: Error thrown for invalid credentials.
- **err-insufficient-fee**: Error thrown if the verification fee is not paid.
- **err-certification-revoked**: Error thrown if a certification has been revoked.
- **err-invalid-skill**: Error thrown if an invalid skill is provided.
- **err-invalid-id**: Error thrown if an invalid certification ID is provided.

## Data Structures

### Data Variables

- **verification-fee**: Stores the fee in microstacks required for certification verification.
- **certification-expiration**: Stores the expiration period (in days) for certifications.
- **cert-count**: Tracks the total number of certifications issued.
- **revoked-certifications**: Tracks the number of certifications that have been revoked.

### Maps

- **certificates**: A map of certification IDs to certificate data.
- **holder-certifications**: A map of holders to their certification IDs.

## Admin Operations

Certain functions can only be executed by the contract owner:

- **update-verification-fee**: Change the fee for certification verification.
- **set-certification-expiration**: Set the expiration period for certifications.
- **reset-certifications-count**: Reset the total number of certifications issued.
- **get-revoked-certifications-list**: Retrieve a list of all revoked certifications.
- **add-new-skill**: Add new skill types to the system.

## Security

The contract includes several measures to ensure the security of certification verification:

- **Fee Handling**: The contract securely transfers the verification fee to the contract owner before processing certification verifications.
- **Revocation Protection**: Certifications that have been revoked cannot be verified.

## Unit Testing

Unit tests can be run on functions like `issue-certification` to ensure that the contract behaves as expected:

```clarity
(define-public (test-certification-issuance (holder principal) (skill (string-ascii 50)))
    (begin
        (let ((cert-id (issue-certification holder skill)))
            (asserts! (is-ok cert-id) err-certification-not-found)
            (ok "Certification issued successfully"))))
```

## UI Integration

This contract can be integrated with a frontend user interface (UI) to allow certification holders to interact with the system, including issuing and verifying certifications, checking validity, and updating skills. A UI page for admins can also be created to manage the certification system, such as viewing revoked certifications and adding new skills.

---

For any questions, please contact the contract owner or refer to the documentation.