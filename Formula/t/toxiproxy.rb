class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "6fe013a718a2d3595b26cd51536dfe3f32a1e346df7a7692e85c65c2cb1b680a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a731a98a748508b9d30866368f0fa1ca15095ae5aa31f92eada27542bfd3846"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90bb61e1fb947cd1907fdcb9bf3cf034dadc3a98ed14fc9e690c408590ccc404"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d77388955bf69f8f43343f3ad967036273ae4a5f15650c1abd4eacdda0d8c37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b68202f84502dee115b8e29991fc53f807cf5ce3d896f5942ebb502fce11aad1"
    sha256 cellar: :any,                 x86_64_linux:      "78bc05c61235f417fe515c0300f35bf12965e9128294cf0d2509aea5fa719a3e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/Shopify/toxiproxy/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"toxiproxy-server"), "./cmd/server"
    system "go", "build", *std_go_args(ldflags:, output: bin/"toxiproxy-cli"), "./cmd/cli"
  end

  service do
    run opt_bin/"toxiproxy-server"
    keep_alive true
    log_path var/"log/toxiproxy.log"
    error_log_path var/"log/toxiproxy.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toxiproxy-server --version")
    assert_match version.to_s, shell_output("#{bin}/toxiproxy-cli --version")

    proxy_port = free_port
    fork { system bin/"toxiproxy-server", "--port", proxy_port.to_s }

    upstream_port = free_port

    fork do
      server = TCPServer.new(upstream_port)
      body = "Hello Homebrew"
      loop do
        socket = server.accept
        socket.write "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: text/plain; charset=utf-8\r\n" \
                     "Content-Length: #{body.bytesize}\r\n" \
                     "\r\n"
        socket.write body
        # Don't close the socket here; toxiproxy expects to close the connection
      end
    end

    sleep 3

    listen_port = free_port
    system bin/"toxiproxy-cli", "--host", "127.0.0.1:#{proxy_port}", "create",
                                "--listen", "127.0.0.1:#{listen_port}",
                                "--upstream", "127.0.0.1:#{upstream_port}",
                                "hello-homebrew"

    assert_equal "Hello Homebrew", shell_output("curl -s http://127.0.0.1:#{listen_port}/")
  end
end
