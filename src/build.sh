nasm -f bin boot.asm -o boot.bin
nasm -f bin shell.asm -o shell.bin
nasm -f bin brainfuck.asm -o brainfuck.bin
nasm -f bin view.asm -o view.bin
nasm -f bin save.asm -o save.bin
nasm -f bin edit.asm -o edit.bin

rm -f BOSS.img
dd bs=512 count=2880 if=/dev/zero of=BOSS.img
dd status=noxfer conv=notrunc if=boot.bin of=BOSS.img
dd seek=1 conv=notrunc if=help.txt of=BOSS.img
dd seek=2 conv=notrunc if=shell.bin of=BOSS.img
dd seek=3 conv=notrunc if=brainfuck.bin of=BOSS.img      # write sector 4
dd seek=4 conv=notrunc if=view.bin of=BOSS.img
dd seek=5 conv=notrunc if=save.bin of=BOSS.img
dd seek=6 conv=notrunc if=edit.bin of=BOSS.img
dd seek=7 conv=notrunc if=source.bf of=BOSS.img

rm boot.bin shell.bin brainfuck.bin view.bin save.bin edit.bin

qemu-system-i386 -fda BOSS.img
