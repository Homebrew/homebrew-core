class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.8.0/traefik-v2.8.0.src.tar.gz"
  sha256 "c45e2418bdf69c396c1ad3d87cb7a8fb5bf9f27f18e1bcd7b7914cfdf2af963e"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe3219ddf20734ddc5d150af898d6c740e916c6ccfbffce152714f6d54953e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfa00316927b38632730cc639b7a53fd7d6017da42fd37d1c76dd9dcd8afb8e0"
    sha256 cellar: :any_skip_relocation, monterey:       "0eac8ef01d2779c06966742da542a90931fd7a8837f492d51e44b730a00844c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e1eed53f152e7d95440ce9abf9a391f461b503c21d8994fe69e77b99f759a08"
    sha256 cellar: :any_skip_relocation, catalina:       "d0dab0fc92add98a0cabc7741fa711a6d21ba356364d620da9cc15f4d19674e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d467d9287dc7422ac43299ba6665245b6d462b42de190e2fbb60453b2cfe375b"
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
