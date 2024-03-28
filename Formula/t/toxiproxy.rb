class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "20edde34342f3209159f22ad9ee0eb4a57f3c47246dbe69b05ae33895cf931ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f5c14bbb252d3529723055a06282be93e627161e64134ca21d80fc8755e29fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8512fb17bae1dcac2ac114a59fd93dcdf8470d7bc0143629bb67444b7348f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c3adb59a2232b888ed21466760ece732ca7b19105240e771aa4fbda5497ccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b44695be480947c0347cf727400a4407f7535b304923416e8027f226d2eb6a0"
    sha256 cellar: :any_skip_relocation, ventura:        "4cf49725a6044cc2de2c1893c36b70fcc1dc4f1ae88b7a43d9c2a1badae55e36"
    sha256 cellar: :any_skip_relocation, monterey:       "72f69a2c602446b870a61b63dff964245e23ddfbc5c56c7cd577acbf9a61519d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc05d85b995ed7b2ca00d1637dbb19f0aef2af43afee8f8ea317fb02d7082f9"
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
