class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.4.13/traefik-v2.4.13.src.tar.gz"
  sha256 "b6ca4b74ead11c19bf9ab2e9ab6b08d05b6c80a5c63be0b2c943f57f9a1767e3"
  license "MIT"
  head "https://github.com/traefik/traefik.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9b40e9b27fb1242a1019e9248d3f16df701d2ec9b901715d1a3f3e2a1e322f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "8945c5e890858446c32105ede9883ead2b36e106ed716fd8eda4722f72a7bbce"
    sha256 cellar: :any_skip_relocation, catalina:      "e472f5d46c3402cf16e914b2b22aca0e8431aee70587ca1d2d5908b1dacd6e34"
    sha256 cellar: :any_skip_relocation, mojave:        "1171c9c8aea7d974a5be78e1fbf5c5e0928218be1eac9e31312d1f84ba32c61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3219bcf8b6c842bcdb415111750d665e939de5ca662cfc7c897aebacddc5c2a9"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go", "generate"
    system "go", "build",
      "-ldflags", "-s -w -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}",
      "-trimpath", "-o", bin/"traefik", "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc/"traefik/traefik.toml"}"]
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
