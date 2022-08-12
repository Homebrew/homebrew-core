class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.3/traefik-v2.8.3.src.tar.gz"
  sha256 "fff69f8d593a2499fcda2c630656f23b01ac0647f6891d513c1e69d7b47d28fb"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58d110195fe309754d4dbc6c652614ca1f8ffe824f3a7cd424e55e0aa7a4d551"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e930f271d1fbf4c47c97f646208fa538f01affd549b244ebc138052edecc9eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "e739622e0da28e30a2d02e6b8d43da19636f71237c632f2f27ed48844c0e6f00"
    sha256 cellar: :any_skip_relocation, big_sur:        "90bddd9a634355970e851353330fcc719160ddd927aac63ee742e349c3e33f5a"
    sha256 cellar: :any_skip_relocation, catalina:       "13a002f957498d7392b2f078fe08e30547f99f6ee82a9bcfb924e51cd168e384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b13af2314be85a5bb11be4ea68427edf273e5650aa2787a1bb3c7a2e8bdcbe"
  end

  depends_on "go-bindata" => :build
  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
