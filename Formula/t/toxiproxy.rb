class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "9332a884c559fbcf96cbe2c1b46312eb1e1b7191eb9a73a3d3b857d4e9789eb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "366a468183e8c98dae90c4ce3dfaa6f740117e4d9485aee8caf687eac0b3b2eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "294a21ff88b3b908d344de82803ff4d66bbeb6834bc42e0b503a4681f497ecb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe38bd275653854eaeea1f762c9abbda9288e803da31118cd29a2d2ee0347553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2fad1caee2311b6102a1f58d5f3a30de56f5df9f7e6a462ac3edebc36a64af9"
    sha256 cellar: :any_skip_relocation, sonoma:        "34c15b5c0ee7761719352512657dfabfe1971b672dc498f0dde8b31a066ae17b"
    sha256 cellar: :any_skip_relocation, ventura:       "8ab0b56d6ca497ad409b54a3f04c472faf10c972873a5fb07799655439b07e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be11e08a83dc827210a32100c31f7d94533b1dc526ee8b8ae597ab48d7e0454e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff23599856b2b7c08cd3873700a345b07480950ceb7f8d4484c6efaf492b6788"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Shopify/toxiproxy/v2.Version=#{version}"
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
