; extends

; Inject bash for block scalars starting with #!/bin/bash
((block_node
  (block_scalar) @injection.content)
  (#lua-match? @injection.content "#!/bin/bash")
  (#set! injection.language "bash")
  (#offset! @injection.content 0 1 0 0))

; Inject bash for block scalars starting with #!/usr/bin/env bash
((block_node
  (block_scalar) @injection.content)
  (#lua-match? @injection.content "#!/usr/bin/env bash")
  (#set! injection.language "bash")
  (#offset! @injection.content 0 1 0 0))

; Inject bash for block scalars starting with #!/bin/sh
((block_node
  (block_scalar) @injection.content)
  (#lua-match? @injection.content "#!/bin/sh")
  (#set! injection.language "bash")
  (#offset! @injection.content 0 1 0 0))

; Inject bash for block scalars starting with #!/usr/bin/env sh
((block_node
  (block_scalar) @injection.content)
  (#lua-match? @injection.content "#!/usr/bin/env sh")
  (#set! injection.language "bash")
  (#offset! @injection.content 0 1 0 0))
