class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "f6ed552edce83bab7ecccbfa4aab9d6fbac42ff152498e8fddf760691f7152a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0c6fcf9fe2a64336f148ae700ab533e03238ab7dee434adb0e2db59bc25967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f0c6fcf9fe2a64336f148ae700ab533e03238ab7dee434adb0e2db59bc25967"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f0c6fcf9fe2a64336f148ae700ab533e03238ab7dee434adb0e2db59bc25967"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69245b262509513e2a12671e72d104156abb8eb7ea7d3901542342b1de6e1a1"
    sha256 cellar: :any_skip_relocation, ventura:       "e69245b262509513e2a12671e72d104156abb8eb7ea7d3901542342b1de6e1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9566d50a0e832b6db409fd354a84ebfe69732554e39c86ff41a3c19cc35179cc"
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
