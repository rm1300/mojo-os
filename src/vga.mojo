comptime VGA_COLOR_BLACK = 0
comptime VGA_COLOR_BLUE = 1
comptime VGA_COLOR_GREEN = 2
comptime VGA_COLOR_CYAN = 3
comptime VGA_COLOR_RED = 4
comptime VGA_COLOR_MAGENTA = 5
comptime VGA_COLOR_BROWN = 6
comptime VGA_COLOR_LIGHT_GREY = 7
comptime VGA_COLOR_DARK_GREY = 8
comptime VGA_COLOR_LIGHT_BLUE = 9
comptime VGA_COLOR_LIGHT_GREEN = 10
comptime VGA_COLOR_LIGHT_CYAN = 11
comptime VGA_COLOR_LIGHT_RED = 12
comptime VGA_COLOR_LIGHT_MAGENTA = 13
comptime VGA_COLOR_LIGHT_BROWN = 14
comptime VGA_COLOR_WHITE = 15


fn vga_entry_color(fg: UInt8, bg: UInt8) -> UInt8:
    return fg | (bg << 4)


fn vga_get_default_color() -> UInt8:
    return vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK)


fn vga_entry(c: UInt8, color: UInt8) -> UInt16:
    return c.cast[DType.uint16]() | (color.cast[DType.uint16]() << 8)


comptime VGA_WIDTH = 80
comptime VGA_HEIGHT = 25

comptime VGA_BUFFER = 0xB8000


fn _vga_write(offset: Int, value: UInt16):
    var addr = VGA_BUFFER + offset * 2

    var ptr = __mlir_op.`llvm.inttoptr`[_type = __mlir_type.`!llvm.ptr`](
        __mlir_op.`builtin.unrealized_conversion_cast`[_type = __mlir_type.i32](
            Int32(addr)
        )
    )

    __mlir_op.`llvm.store`(
        __mlir_op.`builtin.unrealized_conversion_cast`[_type = __mlir_type.i16](
            Int16(value.cast[DType.int16]())
        ),
        ptr,
    )


fn vga_write_string_at(message: StringSlice, row: Int, col: Int, color: UInt8):
    var pos = row * VGA_WIDTH + col

    for i in range(len(message)):
        var char_code = message.as_bytes()[i]
        _vga_write(pos + i, vga_entry(char_code, color))


fn vga_clear_screen(color: UInt8):
    var blank = vga_entry(0x20, color)

    for i in range(VGA_WIDTH * VGA_HEIGHT):
        _vga_write(i, blank)


fn vga_init():
    var color = vga_get_default_color()
    vga_clear_screen(color)
