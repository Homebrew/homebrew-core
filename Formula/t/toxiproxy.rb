class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "20edde34342f3209159f22ad9ee0eb4a57f3c47246dbe69b05ae33895cf931ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec2d776d327160fdf54ff05e6bea22d97d791fab714bc3237a3a741adcb4c1a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7b48c1ae0a20845cb6b03a4e3b4748dd5cbbab0c558793e1cf88572f7678223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376f48a84e1b3eb4e5c255616c0d6232093dfca3e53023d527a5dd81099944d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e726354f2a82b70c5145998588f9f49973c917c29016a53b291fdcac7a8e62a"
    sha256 cellar: :any_skip_relocation, ventura:        "cf6eac25e9fa4c7e42b0ed31da8f733a7220c3e6266a3cd04bfb980651fdf3cc"
    sha256 cellar: :any_skip_relocation, monterey:       "b3f27565464cecf7e59a1c376cdb1381b196f3d4e14ed021b38d68a196923a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6971436e62058ea8f1f74b08c082a396a81b06e39601832491a1796aaafa44e"
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
