#https://www.digitalocean.com/community/tutorials/how-to-convert-virtual-machine-image-formats

vboxmanage clonemedium VEME.vdi VEME.img --format raw

qemu-img convert -f raw VEME.img -O qcow2 VEME.qcow2

qemu-img check VEME.qcow2

qemu-img info VEME.qcow2 

# https://youtu.be/enF3zbyiNZA how to run the vm

