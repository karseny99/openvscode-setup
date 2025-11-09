
FROM gitpod/openvscode-server:nightly

## to get permissions to install packages and such
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        clangd \
        cmake \
        gdb \
        g++-15 \
        googletest \
        libboost-dev \
        libtbb-dev \
        make \
        valgrind \
    && rm -rf /var/lib/apt/lists/*        

RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/clang++-15 100 \
	&& update-alternatives --config g++


# C++ extension

# Seems complicated to configure globally for c++20 (see https://clang.llvm.org/docs/JSONCompilationDatabase.html)
# RUN /home/.openvscode-server/bin/openvscode-server \
#         --extensions-dir /home/initialWorkspace/.openvscode-server/extensions \
#         --install-extension llvm-vs-code-extensions.vscode-clangd

# ms-vscode.cpptools not found (and not available in extension view)
# RUN /home/.openvscode-server/bin/openvscode-server \
#         --extensions-dir /home/initialWorkspace/.openvscode-server/extensions \
#         --install-extension ms-vscode.cpptools

RUN mkdir -p /home/initialWorkspace/.vscode
COPY c_cpp_properties.json /home/initialWorkspace/.vscode/
COPY            tasks.json /home/initialWorkspace/.vscode/
COPY           launch.json /home/initialWorkspace/.vscode/
COPY 	       secret /home/.openvscode-server/

# some other folders in VSCode explorer vue to hide
COPY settings.json /home/initialWorkspace/.openvscode-server/data/Machine/

# BUT debug (breakpoints) does nor work!
ENTRYPOINT [ "/bin/sh", "-c", "exec /home/.openvscode-server/bin/openvscode-server --host 0.0.0.0 --connection-token-file /home/.openvscode-server/secret \"${@}\"", "--" ]
