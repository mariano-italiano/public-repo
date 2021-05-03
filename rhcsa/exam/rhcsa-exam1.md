# RHCSA exam tasks

Ensure all the tasks are implemented with firewalld enabled. Your server should be able to survive a reboot. Good luck!


1. Interrup the boot process and reset the root password. Change it to "password" to gain access to the system.

2. Repos are available from the repo server
- at http://repo.example.com/BaseOS
- and http://repo.example.com/AppStream

for you to use during the exam.

3. The system time should be set to your (or nearest to you) timezone and ensure NTP sync is configured.

4. Add the following secondary IP address statically to you current running interface. Do this in a way that doesn't compromise your existing settings:
- ipv4 - 10.0.0.5/24
- ipv6 - fd01::100/64

5. Enable packet forwarding on system. This should persist after reboot.

6. System should boot into a multiuser target by default and boot messgaes should be preset (not silenced).

7. Create a new 2GB volume group named "vgprac".

8. Create a 500MB logical volume named "lvprac" inside the "vgprac" volume group.

9. The "lvprac" logical volume should be formatted with the xfs filesystem and mount persistently on the /mnt/lvprac directory.

10. Extend the xfs filesystem on "lvprac" by 500MB.

11. Use the appropriate utility to create a 5TiB thin provisioned volume.

12. Configure a basic web server that displays "Welcome to the web server" once connected to it. Ensure the firewall allows the http/https services.

13. Find all files that are larger than 5 MB in the /etc/ directory and copy them into /find/largefiles.

14. Write a script named awesome.sh in the root directory on system.
- If "me" is a given as an argument, then the script should output "Yes, I'm awesome"
- If "them" is a given as an argument, then the script should output "Okay, they are awesome"
- If the argument is empty or anything else is given, the script should output "Usage ./awesome.sh me|them"

15. Create users phil, laura, stewart and kevin.
- All users should have a file named "Welcome" in theis home folder after account creation
- All users passwords should expire after 60 days and be at least 8 characters in length 
- phil and laura should be part of the "accounting" group. If the group doesn't already exist, create it.
- stewart and kevin should be part of the "marketing" group. If the group doesn't already exist, create it.

16. Only members of the accounting group should have access to the "/accounting" directory. Make laura the owner of this directory. Make the accounting group the group owner of the "/accounting" directory. 

17. Only members of the marketing group should have access to the "/marketing" directory. Make ststewart the owner of this directory. Make the marketing group the group owner of the "/marketing"

18. New files should be owned by the group owner and only the file creator should have the permissions to delete thier own files.

19. Create a cron job that writes "This practise exam was easy and I'm already reade to ace my RHCSA" to /var/log/messages at 6:00 PM only on weekdays. 
