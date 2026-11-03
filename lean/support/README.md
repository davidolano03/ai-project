# Portable reproduction support

This paper formalization is based on AppliedModelingLib commit
`194edcc95df74806a39b961d10dedddc6e730cce` (the recorded upstream base).
It also needs the three public Gaussian-signal theorem wrappers in
`GaussianSignalRCD-public-wrappers.patch`; vanilla upstream at that commit
does not contain them.

The patch transforms the exact upstream blob
`fd1f65933fbf156364e110fe1832b472cddead83` into blob
`1d6eb45f1e00e75a77e4001fd750cc5712411aaf`.  It contains 40 added lines and
does not change the underlying Gaussian implementation.

## Reproduction in AppliedModelingLib

From a clean checkout at the upstream base:

1. Copy this paper folder to `papers/Olano26Transparencia/`.
2. Copy `support/Olano26Transparencia.lean` to
   `papers/Olano26Transparencia.lean`.
3. Apply the support patch from the repository root:
   `git apply --unidiff-zero papers/Olano26Transparencia/support/GaussianSignalRCD-public-wrappers.patch`.
4. Add the exact `support/lakefile-snippet.toml` block to `lakefile.toml`.
5. Use Lean `4.30.0-rc2` and run `lake build Olano26Transparencia`.

The canonical paper source is pinned separately by `verification/provenance.json`.
The local `.gitignore` deliberately keeps downloaded paper-source artifacts
out of ordinary contribution commits.

## License and provenance

AppliedModelingLib and the support wrappers are provided under Apache License
2.0.  `LICENSE-Apache-2.0.txt` contains the complete repository-root license,
normalized from the checkout's CRLF bytes to portable LF text.
The wrapper patch was added in the local Olano26 checkpoints derived from the
upstream base and remains part of the paper's reproducible dependency surface.

## Windows

La corrida local usó `support/windows-compat/run_paper_contribution.py` y el shim `fcntl.py`: solo adaptan funciones POSIX ausentes en Windows. Desde la raíz de la biblioteca, añadir su ruta a `PYTHONPATH` y ejecutar ese runner con `check Olano26Transparencia --fast`; fijar `TEMP` y `TMP` a una carpeta temporal accesible. En Linux se usa directamente el comando oficial de Python.
