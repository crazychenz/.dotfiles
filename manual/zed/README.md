Repo: https://github.com/zed-industries/zed

Download latest relased binary and relavent servers.

Install zed from tar:

tar -xf ~/Downloads/zed-linux-x86_64.tar.gz -C ~/.local/bin

Install zed server:

Open the client and get the fully hashed version:
`0.218.5+stable.112.2e5d241c6d6c189f4f973b54cb13a9131e7402ce`

Using the version, download and install the server binary in ~/.zed_server

mkdir -p ~/.zed_server
gzip -d ~/Downloads/zed-remote-server-linux-x86_64.gz
chmod +x ~/Downloads/zed-remote-server-linux-x86_64
mv ~/Downloads/zed-remote-server-linux-x86_64 \
  ~/.zed_server/zed-remote-server-stable-0.218.5+stable.112.2e5d241c6d6c189f4f973b54cb13a9131e7402ce



