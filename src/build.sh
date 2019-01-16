nasm -f bin boot.asm -o boot.bin
nasm -f bin shell.asm -o shell.bin

rm -f BOSS.img
dd bs=512 count=2880 if=/dev/zero of=BOSS.img
dd status=noxfer conv=notrunc if=boot.bin of=BOSS.img
dd seek=1 conv=notrunc if=prog.txt of=BOSS.img
dd seek=2 conv=notrunc if=shell.bin of=BOSS.img

rm boot.bin shell.bin

qemu-system-i386 -fda BOSS.img
