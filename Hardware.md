# Hardware & OS specs
A development environment for ZX does not need to be a big iron. 
+ 2 Cores / 2 CPU
+ 2 GB fisical RAM *(and 4 GB of SWAP)*
+ 30 GB Disk
  + /boot/efi *512 MiB*
  + /boot *1 GiB*
  + Logical Volume *25 GiB, leave some unused space* 
    + / *15 GiB*
    + /tmp *1 GiB*
    + /var/tmp *1 GiB*
    + /var/log *4 GiB*
    + SWAP  *4 GiB*
+ 10 GB Disk
  + Logical Volume *Thinking ahead, aiming migrations and Upgrades*
    + /home  *Maybe is sensible not using all availiable space*   
+ 1 Network Interface
+ OS **Ubuntu Server 24.04 LTS**


*Might be interesting to do an unattended installation*
