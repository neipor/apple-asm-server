.equ ERR_NONE, 0
.equ ERR_BAD_REQUEST, 400
.equ ERR_NOT_FOUND, 404
.equ ERR_METHOD_NOT_ALLOWED, 405
.equ ERR_INTERNAL, 500
.equ ERR_BAD_GATEWAY, 502
.equ ERR_SERVICE_UNAVAILABLE, 503

.text
.global _error_code

_error_code:
    ret
