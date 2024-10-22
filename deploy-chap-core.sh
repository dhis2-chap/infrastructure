
# Check if the container exists and delete it if it does
if sudo lxc list | grep -q "chap-container"; then
  sudo lxc delete chap-container --force
fi

sudo lxc launch ubuntu:20.04 chap-container
sudo lxc config device add chap-container myport8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:127.0.0.1:8000
# Wait for the container to initialize
sleep 30 

# Upload the initialization script to the container
sudo lxc file push chap-core-lxd-container-init.sh chap-container/root/

# Make the script executable
sudo lxc exec chap-container -- chmod +x /root/chap-core-lxd-container-init.sh

# Run the initialization script within the container
sudo lxc exec chap-container -- /root/chap-core-lxd-container-init.sh