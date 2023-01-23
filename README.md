This is a docker container to build Zephyr applications.

# Building the container
The container can be built with:
```sh
docker build -t zephyr-build .
```

# Building project
For simplicity with ssh authentication, the zephyr project must be initialized
outside of the container. Once the Zephyr project is initialized, the 
``build-zephyr-app.sh`` script can be used to compile a project. 

The board and application path relative to the workspace can be given as
argument. The Zephyr workspace should be binded within the container into the
``/workspace`` directory.

```sh
docker run \
  --mount type=bind,source=/path/to/zephyr/project,target=/workspace \
  zephyr-build:latest \
  build-zephyr-app.sh --board arduino_zero --app zephyr/samples/basic/blinky
```

The result of the build is then available in ``<workspace>/build-docker``.

# Running twister tests
In the same manner as building an application, it is possible to run twister
tests by specifying the tests location relative to the workspace:

```sh
docker run \
  --mount type=bind,source=(pwd),target=/workspace \
  zephyr-build:latest \
  run-twiset-tests.sh --tests zephyr/tests/kernel/fifo/fifo_api/
```

# Using a specific SDK
By default, the latest SDK will be used for the compilation. If you want to use
a specific SDK version, it can be sepcificed with the ``--sdk-version``
parameter. If the SDK is not available, it will be installed.

For the list of available SDKs, have a lock at the ``Dockerfile``.
