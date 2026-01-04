from vga import *


@export("kmain", ABI="C")
fn kmain():
    vga_init()
    vga_write_string_at("Hello, kernel World!", 0, 0, vga_get_default_color())
