
# Check if the container exists and delete it if it does
if sudo lxc list | grep -q "chap-core"; then
  echo "Deleting existing container..."
  sudo lxc delete chap-core --force
fi

# Delete existing storage pool
sudo lxc storage volume delete docker chap-core
# Wait for the container to be deleted
# Delete the storage pool
sudo lxc storage delete docker
sleep 10


lxc storage create docker btrfs size=100GB
sudo lxc launch ubuntu:24.04 chap-core

# Delete existing storage volume if it exists

# Create new storage volume
lxc storage volume create docker chap-core size=50GB
lxc config device add chap-core docker disk pool=docker source=chap-core path=/var/lib/docker
lxc config set chap-core security.nesting=true security.syscalls.intercept.mknod=true security.syscalls.intercept.setxattr=true

# set environment variables
lxc config set chap-core environment.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY $GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY
lxc config set chap-core environment.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY $GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY

lxc restart chap-core

sudo lxc config device add chap-core chapPort443 proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:8000

# Upload the initialization script to the container
sudo lxc file push chap-core-lxd-container-init.sh chap-core/root/

# Make the script executable
sudo lxc exec chap-core -- chmod +x /root/chap-core-lxd-container-init.sh

# Run the initialization script within the container
sudo lxc exec chap-core -- /root/chap-core-lxd-container-init.sh

# Wait for the container to initialize