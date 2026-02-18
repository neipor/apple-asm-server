.equ H2_FRAME_DATA, 0x0
.equ H2_FRAME_HEADERS, 0x1
.equ H2_FRAME_SETTINGS, 0x4
.equ H2_FRAME_PING, 0x6
.equ H2_FRAME_GOAWAY, 0x7
.equ H2_FRAME_WINDOW_UPDATE, 0x8

.text
.global _h2_decode_frame
.global _h2_decode_headers
.global _h2_decode_data

_h2_decode_frame:
    ret

_h2_decode_headers:
    ret

_h2_decode_data:
    ret
