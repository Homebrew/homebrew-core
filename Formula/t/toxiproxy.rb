class Toxiproxy < Formula
  desc "TCP proxy to simulate network & system conditions for chaos & resiliency testing"
  homepage "https://github.com/shopify/toxiproxy"
  url "https://github.com/Shopify/toxiproxy/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "17bf7580644a5cf8d6fc2b5a71e8dc7931528838724a6e4dc2bb326731fab4c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64e0ff9a28411806ae87d9435342684e9974d1480cef956b664f95cc42bc6d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ca7ee33dbd5f2b6dffb6b36a68bb6aaad07a3fe9efc63f939d6059dcce97a64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4c757ee32deb7a6ca42495f0a6c0dd87167b9e814463ba2abe26e012189ac7f"
    sha256 cellar: :any_skip_relocation, ventura:        "272710c598c47c6d6c32c630cbd833b1bfa375c53a93d82cb5a8ec83d8866c44"
    sha256 cellar: :any_skip_relocation, monterey:       "13d2677ae0d1a135ae1dc417f215938c72c5f70475830f02a0550832c1f727da"
    sha256 cellar: :any_skip_relocation, big_sur:        "d86774ab5bca34406c63ea8f50346e4e1078561e2c87f72d9b6ffcd24525a4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c87b77bdb16c7d0fa16fc6fdf25bd804a70c9ba21ed041519cb507ae2bb68b"
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
    require "webrick"

    assert_match version.to_s, shell_output(bin/"toxiproxy-server --version")
    assert_match version.to_s, shell_output(bin/"toxiproxy-cli --version")

    proxy_port = free_port
    fork { system bin/"toxiproxy-server", "--port", proxy_port.to_s }

    upstream_port = free_port
    server = WEBrick::HTTPServer.new Port: upstream_port
    server.mount_proc("/") { |_req, res| res.body = "Hello Homebrew" }

    Thread.new { server.start }
    sleep(3)

    begin
      listen_port = free_port
      system bin/"toxiproxy-cli", "--host", "127.0.0.1:#{proxy_port}", "create",
                                  "--listen", "127.0.0.1:#{listen_port}",
                                  "--upstream", "127.0.0.1:#{upstream_port}",
                                  "hello-homebrew"

      assert_equal "Hello Homebrew", shell_output("curl -s http://127.0.0.1:#{listen_port}/")
    ensure
      server.shutdown
    end
  end
end
