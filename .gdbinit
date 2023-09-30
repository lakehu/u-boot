set output-radix 16

# 1. Set a breakpoint at board_init_r => setup_reloc
#b board_init_r
b setup_reloc
# 2. When the breakpoint is hit, retrieve gd->relocaddr
commands
silent
set $s = (gd_t *)gd
set $relocaddr = $s->relocaddr
printf "Get relocaddr : 0x%x\n",$relocaddr
continue
end

b relocate_code
commands
silent
# 3. Discard old symbol information
symbol-file

# 4. Load symbol information from the new relocation address
add-symbol-file u-boot $relocaddr
printf "Reload symbol at: 0x%x\n",$relocaddr
# This is the 1st C function after relocation is done.
b board_init_r
b initr_trace
# main loop of Uboot  (Question main_loop is optimized? can't break)
b cli_init

# 5. Continue execution and debug with the new relocated address
continue
end 



