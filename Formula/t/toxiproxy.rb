class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "642b6f590ef5b26418663983aa1d86f9120c8c1339034116a08da4d2231e0504"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "247537befa839cfa0c4a8e6d01b215796a8df7cfdecb958d626b8bd89a4625dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247537befa839cfa0c4a8e6d01b215796a8df7cfdecb958d626b8bd89a4625dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "247537befa839cfa0c4a8e6d01b215796a8df7cfdecb958d626b8bd89a4625dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f3c7b314262d9c223dc749765f3603b3eeb8226b05168fc2aef7c0e67fdaf6a"
    sha256 cellar: :any_skip_relocation, ventura:       "3f3c7b314262d9c223dc749765f3603b3eeb8226b05168fc2aef7c0e67fdaf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfc24ff1aaab01335f8425a1c94bbcf5d4d3db94f3fe9f7c20d3f49c9442cacd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Shopify/toxiproxy/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"toxiproxy-server", "./cmd/server"
    system "go", "build", *std_go_args(ldflags:), "-o", bin/"toxiproxy-cli", "./cmd/cli"
  end

  service do
    run opt_bin/"toxiproxy-server"
    keep_alive true
    log_path var/"log/toxiproxy.log"
    error_log_path var/"log/toxiproxy.log"
  end

  test do
    assert_match version.to_s, shell_output(bin/"toxiproxy-server --version")
    assert_match version.to_s, shell_output(bin/"toxiproxy-cli --version")

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
