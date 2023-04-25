class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.0/traefik-v2.10.0.src.tar.gz"
  sha256 "12e6574e632c16cf75aa299569d0d4e2b90b73f50291749fefc2b6d9384bc551"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7c4a87f9346d131bce37f7025764406e10358fa5f1916dcee8a5b4ca9214ce3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c4a87f9346d131bce37f7025764406e10358fa5f1916dcee8a5b4ca9214ce3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7365c4d2a2acd33fa49f531c73806c0656abad27e9b818999dad29ee00e7d13"
    sha256 cellar: :any_skip_relocation, ventura:        "1902a32696d3a486ddb7109b27cea8d0be09fbe9ba1b4a7426bc39f14bdb212d"
    sha256 cellar: :any_skip_relocation, monterey:       "536d70be34e717a1cda527b1d2da0f066c2aacbb5b58b47040831f4c052da9ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e9864878185611b426c4f503bf780118ec3c699ebe2caa1146693f833a8c09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "358e38ebebaed939a86c911e966eb1b7690f32e64a380a53c85fcb6dfef2855f"
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
