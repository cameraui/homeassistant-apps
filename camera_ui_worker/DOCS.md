# camera.ui Worker

Runs camera.ui as a worker for a master instance somewhere else on your network (a mini PC, a Docker host, another machine). The worker has no interface of its own. It connects to the master and runs the cameras and plugins the master hands to it, so you can use this machine's CPU, GPU or Coral for the heavy work.

This is not a standalone camera.ui. If you want the full interface on your Home Assistant machine, use the **camera.ui** add-on instead.

## Setup

On the master first:

1. Open its Settings and turn on workers.
2. Set the worker address to the master's IP on your network, the worker needs it to pull camera streams.
3. Generate a pairing code. It is valid for 15 minutes.

Then here:

1. Set **Master address** to the master's IP.
2. Set **Pairing code** to the code you just generated.
3. Start the add-on.

The worker pairs, stores its connection, and reconnects on its own after that. You only enter the code once.

## Options

### `master_address`

IP or hostname of the master instance on your network.

### `pairing_code`

The code generated on the master. Only needed for the first connection.

### `worker_name`

A name for this worker, shown on the master. Defaults to a generated name.

### `master_api_port`

Only needed if the master runs its interface on a non-default port. Leave empty otherwise.

## First start

The first start downloads the camera.ui server from npm, this needs internet access and takes a few minutes. Plugins the master assigns are downloaded when they are assigned. Later starts are fast.

## Hardware acceleration

Same as the main add-on: Intel/AMD VA-API (amd64), Coral USB and PCIe, Hailo, and Raspberry Pi V4L2 decoding are included and passed through when the devices exist. NVIDIA is not available on Home Assistant OS.

## Network

Host networking, required so the worker can reach the master's streaming ports directly. The worker dials out to the master, so it works behind NAT without any port forwarding.
