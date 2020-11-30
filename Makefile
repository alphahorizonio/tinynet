# All
all: build

# Build
build: \
    build-wasi-sdk \
    build-net-server-native-posix-go \
    build-net-server-native-posix-tinygo \
    build-net-server-wasm-jssi-go \
    build-net-server-wasm-wasi-tinygo \
	build-net-client-native-posix-go \
    build-net-client-native-posix-tinygo \
    build-net-client-wasm-jssi-go \
    build-net-client-wasm-wasi-tinygo

build-wasi-sdk:
	@docker build -t pojntfx/wasi-sdk .

build-net-server-native-posix-go:
	@docker run -v ${PWD}:/src:z golang sh -c 'cd /src && go build -o out/go/net_echo_server ./cmd/net_echo_server/main.go'
build-net-server-native-posix-tinygo:
	@docker run -v ${PWD}:/src:z tinygo/tinygo sh -c 'cd /src && mkdir -p out/tinygo && tinygo build -o out/tinygo/net_echo_server ./cmd/net_echo_server/main.go'
build-net-server-wasm-jssi-go:
	@docker run -v ${PWD}:/src:z -e GOOS=js -e GOARCH=wasm golang sh -c 'cd /src && go build -o out/go/net_echo_server.wasm ./cmd/net_echo_server/main.go'
build-net-server-wasm-wasi-tinygo: build-wasi-sdk
	@docker run -v ${PWD}:/src:z tinygo/tinygo sh -c 'cd /src && mkdir -p out/tinygo && tinygo build -heap-size 20M -cflags "-DBERKELEY_SOCKETS_WITH_CUSTOM_ARPA_INET" -target wasi -o out/tinygo/net_echo_server_wasi_original.wasm ./cmd/net_echo_server/main.go'
	@docker run -v ${PWD}:/src:z pojntfx/wasi-sdk sh -c 'cd /src && wasm-opt --asyncify -O out/tinygo/net_echo_server_wasi_original.wasm -o out/tinygo/net_echo_server_wasi.wasm'

build-net-client-native-posix-go:
	@docker run -v ${PWD}:/src:z golang sh -c 'cd /src && go build -o out/go/net_echo_client ./cmd/net_echo_client/main.go'
build-net-client-native-posix-tinygo:
	@docker run -v ${PWD}:/src:z tinygo/tinygo sh -c 'cd /src && mkdir -p out/tinygo && tinygo build -o out/tinygo/net_echo_client ./cmd/net_echo_client/main.go'
build-net-client-wasm-jssi-go:
	@docker run -v ${PWD}:/src:z -e GOOS=js -e GOARCH=wasm golang sh -c 'cd /src && go build -o out/go/net_echo_client.wasm ./cmd/net_echo_client/main.go'
build-net-client-wasm-wasi-tinygo: build-wasi-sdk
	@docker run -v ${PWD}:/src:z tinygo/tinygo sh -c 'cd /src && mkdir -p out/tinygo && tinygo build -heap-size 20M -cflags "-DBERKELEY_SOCKETS_WITH_CUSTOM_ARPA_INET" -target wasi -o out/tinygo/net_echo_client_wasi_original.wasm ./cmd/net_echo_client/main.go'
	@docker run -v ${PWD}:/src:z pojntfx/wasi-sdk sh -c 'cd /src && wasm-opt --asyncify -O out/tinygo/net_echo_client_wasi_original.wasm -o out/tinygo/net_echo_client_wasi.wasm'

# Clean
clean: \
    clean-net-server-native-posix-go \
    clean-net-server-native-posix-tinygo \
    clean-net-server-wasm-jssi-go \
    clean-net-server-wasm-wasi-tinygo \
	clean-net-client-native-posix-go \
    clean-net-client-native-posix-tinygo \
    clean-net-client-wasm-jssi-go \
    clean-net-client-wasm-wasi-tinygo

clean-net-server-native-posix-go:
	@rm -f out/go/net_echo_server
clean-net-server-native-posix-tinygo:
	@rm -f out/tinygo/net_echo_server
clean-net-server-wasm-jssi-go:
	@rm -f out/go/net_echo_server.wasm
clean-net-server-wasm-wasi-tinygo:
	@rm -f out/tinygo/net_echo_server_wasi_original.wasm
	@rm -f out/tinygo/net_echo_server_wasi.wasm

clean-net-client-native-posix-go:
	@rm -f out/go/net_echo_client
clean-net-client-native-posix-tinygo:
	@rm -f out/tinygo/net_echo_client
clean-net-client-wasm-jssi-go:
	@rm -f out/go/net_echo_client.wasm
clean-net-client-wasm-wasi-tinygo:
	@rm -f out/tinygo/net_echo_client_wasi_original.wasm
	@rm -f out/tinygo/net_echo_client_wasi.wasm

# Run
run: \
    run-net-server-native-posix-go \
    run-net-server-native-posix-tinygo \
    run-net-client-native-posix-go \
    run-net-client-native-posix-tinygo

run-net-server-native-posix-go:
	@./out/go/net_echo_server

run-net-server-native-posix-tinygo:
	@./out/tinygo/net_echo_server

run-net-client-native-posix-go:
	@./out/go/net_echo_client

run-net-client-native-posix-tinygo:
	@./out/tinygo/net_echo_client