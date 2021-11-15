class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.5.4/traefik-v2.5.4.src.tar.gz"
  sha256 "4cf1f65bf4665e08f97491f099114d659ff2785989b06f8360eeaddcc3abb728"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e313e9fb7ecd1d34d0780f41b23038693305c9ef5c99a0a487d9a7dc82ad8c7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84aead677a9beb34e4be9f4e5e2e5c76e220a4da58d425b2addc4c0a1eb4aeda"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5184138ae1d54d682b1325bc29acf179c7b2b0795309dd22d43278e6fdafb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7ce61baff5d862790d201869602c7035c97c5047d97a3fbdc3fc6428c168656"
    sha256 cellar: :any_skip_relocation, catalina:       "908ccdba1086de46152e991ab40bb213e25d569adc0eeeebc2f8d9ff3a0fdaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8302a22363f8b263333f3ab7277792bcf76a8d91ada2d75858a7d6833cf494f1"
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
