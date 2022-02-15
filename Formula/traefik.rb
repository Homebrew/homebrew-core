class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.6.1/traefik-v2.6.1.src.tar.gz"
  sha256 "06c24b339c8896cd8c2a88f85b1d6851ee2fcf9186169a7ff9df0ec87a0ed35e"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb89ee32e664f48fad319be5da6f2d0609af52c67c70da66c5d72fa101d7fae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4b567bb16bc44a9f875f7505e0ee6bb331eeb06eadbf1d3c4854e5a9eda222e"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b571a3cc93abb65eeb09a944432670224f698d54078b8509b7785445438478"
    sha256 cellar: :any_skip_relocation, big_sur:        "24b3573d989f5640fb8871c029e7c4c3a4946eae2c019e9af1ed3d4239931cdf"
    sha256 cellar: :any_skip_relocation, catalina:       "d67dd67f6a80c925284f740e1f629e5e01bf14518e05a3e506d46803aa4eb9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b06eab3dbea978997d4ceeb300df7384494d61855fc55c3def7dbf4c4df992"
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
