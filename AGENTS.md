# Agent instructions

<!-- operator-delivery-standard:v1 -->
## Delivery and validation standard

This is the standing standard for all work until the user explicitly changes it.

Focus on happy paths and obvious failure modes. Deliver the smallest sound, usable change that meets the requested scope.

- Validate changed behavior with meaningful tests.
- Investigate deeper cases when concrete defects, failed checks or realistic usage provide evidence that they matter.
- Do not add exhaustive edge-case matrices, mutation campaigns, coverage polishing or repeated proof runs by default.
- Reuse valid evidence for unchanged code. Repeat testing when a relevant change or actual failure warrants it.
- Required CI checks and established security and financial safeguards remain binding.
- Merge when the requested behavior is adequately covered and required checks pass. Handle further refinements through realistic use and testing.

This ruling overrides earlier repository-local and shared guidance requiring additional validation by default.
<!-- /operator-delivery-standard:v1 -->
