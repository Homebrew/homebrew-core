class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.1/traefik-v2.10.1.src.tar.gz"
  sha256 "34c19da8a28e10e5634afd7336a9b7944dbf21bfbacf4248d0140c329ef0049f"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a712a6ef26f75aee46726c886e4585fb13c6ce0c04a71dda7a97540f071ad257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a712a6ef26f75aee46726c886e4585fb13c6ce0c04a71dda7a97540f071ad257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08d7322a47ea7b05888c22906cba20283b2bcdf72ff89711bc9fa03e392f61a2"
    sha256 cellar: :any_skip_relocation, ventura:        "722fd83aacc228c97cd71a4f38046423c86d9189b02951fa3de3fc939c22fffa"
    sha256 cellar: :any_skip_relocation, monterey:       "55d8d71d9993de291a341b6d0a7b2ea1f87a3210a9b4776a99ed11b507ee9b39"
    sha256 cellar: :any_skip_relocation, big_sur:        "24fd6826162703cc9104a3614a40f062ef79c8b6f205942797f7ba719857690a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7690c3f887251aa7054b0958a8b320b279b0a9a2ce0ee5896d6946f34f10ed61"
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
