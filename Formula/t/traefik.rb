class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.10.4/traefik-v2.10.4.src.tar.gz"
  sha256 "d47d61d1a240c4502a8a467987394f10ebf97554be2a93534df3eba3e32d5788"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ac1ccf2902a09befe1f3f6e720486429b5b4483de407a43b16dd83153e46f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ac1ccf2902a09befe1f3f6e720486429b5b4483de407a43b16dd83153e46f55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac1ccf2902a09befe1f3f6e720486429b5b4483de407a43b16dd83153e46f55"
    sha256 cellar: :any_skip_relocation, ventura:        "bbdb02446db1fae950d9690c744d5ce527f7d093fc49c327b77b8e343456e511"
    sha256 cellar: :any_skip_relocation, monterey:       "9119342da47f752c6b0bfc26404c77d305b05ad5e46f19b3be2774f5a62f8a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed923e2b55eaaf7f5640e9160fabcaff20dd248a6580a2c38477f603e7a15970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eee0330f8c7c7cc759c8834078d804a43c685ab6190bfae68dfcdff06fdd7484"
  end

  # pin to 1.20 needed for release <= 2.10.4, which doesn't yet include https://github.com/traefik/traefik/pull/10078
  depends_on "go@1.20" => :build

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
