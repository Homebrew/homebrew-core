class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.5/traefik-v2.8.5.src.tar.gz"
  sha256 "8b19cdab130813ace1856cadb5ee4987b625e6f6068eea85e38e5b26fa7ac3be"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "443d41b7ff15670d33b9999b703983333bafc3a14255b5fe13675701d8b35ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afbaeb3062e8d717753c1ea6c1715604a6705aa417d462e87ed589d4925ef4dc"
    sha256 cellar: :any_skip_relocation, monterey:       "2afba762d3728df5bbbaa93be993fefc2826a3771e2f0ae5bb32798d421e92ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "cec9dd39f362e35c677c54c032364142ebd72cf10e826b421728a3b51b53762f"
    sha256 cellar: :any_skip_relocation, catalina:       "a92612fba20801894a49d9b5dc970442a26828292bcc3b1aef024b47c0b330f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d497ad47ebafb1cca5b6f35e556bb7f17e23ca294553908af5e1311ebe95064"
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
