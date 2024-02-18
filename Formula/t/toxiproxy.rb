class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "e61c3fac7cfb21ec9df2c176dcc5b999a588468068094d0255cb7a2dd2688684"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e5c0afeb5de29d2534866a8bd1e9404a1ca70080ecf407e29183209daea55fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b1b5912a07a226f062db310e5e06295e73ea9454c97388efb74d127c75e21ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "961e7e0babc0195ba7bd697773a64f6c97ccda87bc724913cef2a1eb8c25bdf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "da3d4c1206cbd854d1c1394fdb1cbf4d0e63e8f1a19d267116934c7e8bbbd7d0"
    sha256 cellar: :any_skip_relocation, ventura:        "86d41e03b7ea36c163080accbe4f4c441d55d67238488b2a701ed879d0a68efc"
    sha256 cellar: :any_skip_relocation, monterey:       "e06b8bc2b989e2200d2d726f7b5fd2346fbc52edff908242219b0b6b0a9c97b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a0aab193d86a1bb4f8020e0b18a1e8cadf68e981f1705db766f151c2952eff4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Shopify/toxiproxy/v2.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"toxiproxy-server", "./cmd/server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"toxiproxy-cli", "./cmd/cli"
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
