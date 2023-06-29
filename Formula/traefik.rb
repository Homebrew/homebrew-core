class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.3/traefik-v2.10.3.src.tar.gz"
  sha256 "eb4694ef72a8356a2acf36315e5e141027001c1eef8acade7ecb86512305d286"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b1f7935ea892decfc8131576f93518cbe90007f008ba4143d7fc2e64b18007a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b1f7935ea892decfc8131576f93518cbe90007f008ba4143d7fc2e64b18007a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b1f7935ea892decfc8131576f93518cbe90007f008ba4143d7fc2e64b18007a"
    sha256 cellar: :any_skip_relocation, ventura:        "3e99b8faed20a671ecc9dc9679608198faf8cfce6306dfc649cd31041607dbd6"
    sha256 cellar: :any_skip_relocation, monterey:       "70f0244a2fcee28052968a9b86e4229cd733935004c1072441ffc1871f2ce167"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e915381506e60af05d0507ad3d495e8c6be38ecff7b1371a71aaf3ea11372d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e55ac5569c031cc0110435119d2459b5be1841db503d59f3764cc4777e608c"
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
