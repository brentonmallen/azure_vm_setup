# azure_vm_setup
A repo to house scripts, tools, etc for bootstrapping and working with Azure VMs. While this is geared more towards the Python ML/AI stack, maybe this could be useful for others.

This is just a list of notes/scripts/tips for when setting up, and working with, a [VM in Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/).


## Machine Setup
- Configure and start the VM (Azure Console)
  - Work with OPS to get prerequisits setup for things like ssh certs etc.
- Obtain the public IP address for the machine
  - Set up the ssh agent config to provide the key, user, and set it for forwarding for the host IP
  ```
  Host vm_ip_address
    AddKeysToAgent yes
    User username
    IdentityFile ~/.ssh/id_ed12345
    ForwardAgent yes
  ```

- ssh into the maching with `ssh user@ip`

## Bootstrapping
To install system dependencies, either run the `bootstrap.sh` script or execute it's components as needed.

Note: The script may need to be made executable via `chmod +x bootstrap.sh` on the remote machine

**Steps**
- Either:
  - clone this repo to the machine
  - copy the script file (either via `scp` or some equivalent)
  - copy and paste the commands into the terminal

After the gpu drivers are installed, the machine will have to be rebooted.  Once it's rebooted, reconnect.


## Development
- Clone the repo of interest to the machine
- Ensure the python dependencies are installed by using a command like `uv sync --all-packages` within the repo
- Using git to manage changes is a helpful way to keep work safe in case the machine gets deleted and data gets deleted


## Working in the VM
- VS Code
  - Setup remote connection using the [remote ssh extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
  - I haven't used this so I will update when I do, or feel free to update it via a PR
- Jupyter Notebook
  - spin up the jupyter lab server on the remote machine: `uv run jupyter lab --no-browser --port=9999`
    - This sets the port to 9999, just to keep it different from default
  - On the local machine, create a tunnel to the server via: `ssh -L 9999:localhost:9999 username@<remote_ip>`
  	- The first port number is the local port number being used. So, if the jupyter hub server, on the remote machine, is using the default port, this should be changed to `8888:localhost:8888` (assuming you want to use the default port locally as well).
  	- If you want to keep the remote machine using the default jupyter port, but want to use a different one locally, it would be `ssh -L [LOCAL_PORT]:[DESTINATION_HOST]:[DESTINATION_PORT] [USER]@[SSH_SERVER]`. So something like `9999:localhost:8888`


## Tips
- Github CLI
  - The github-cli can be used to create gists as an easy way to share notebooks/files before/outside making a commit
  - The easiest auth method for using this is to setup a personal access token in github for your account; giving it the appropriate permissions.
    - Set the environment variable via: `export GH_TOKEN=<PersonalAccessToken>`
- `scp` and `rsync`
  - These can be used to move files back and forth between the VM and local machine for things that you may not want committed but want to retain. Could also be used for putting data files up onto the VM to use for things like training, etc especially if they aren't in Blob Storage / network accessible
  - To use `scp` to copy files from VM to a local path `scp -r username@remote_ip:path/on/vm local/path`
  - To use `rsync` to sync files incrementally (only files that have changed): `rsync -avzh --progress [remote_user]@[remote_host]:/remote/source/path/ /local/destination/path/`

- HuggingFace Model Download
  - Downloading huggingface models can be an issue sometimes when trying to do it within python.
  - Do it manually with the huggingface-cli:
```
uvx hf download prajjwal1/bert-mini
uvx hf download prajjwal1/bert-tiny
```
