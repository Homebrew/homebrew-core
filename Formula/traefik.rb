class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.7/traefik-v2.5.7.src.tar.gz"
  sha256 "1c7d0af60e83790abd887f0394d36b97824287f1cb238998fff96cf059e4b2c9"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a28fdfcdcdaacf9d6550a23a934d5c65de258c8bac6a2eb4be363a9c6f73156"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c3f5942e1e3baec40803d594b01533050bf1ebf70fa5ad67d3a04554b8a8856"
    sha256 cellar: :any_skip_relocation, monterey:       "20b21b78758d69486db548927a6e22e7cee235ed22c2d0e10ee1832e5c64cba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5043098a1a977987984cd70d9588727ee64a24157e6af93942371841f02d53e"
    sha256 cellar: :any_skip_relocation, catalina:       "6e64a035ab1bfec3e650d27d489429a229ae68263b72127ee0a598c921a47553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b696e8c0f83f823df13c21d8a200e90e3d14e955a35d39b03c41dfe11ec5d1e"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ].join(" ")
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
