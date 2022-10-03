class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.1/traefik-v2.9.1.src.tar.gz"
  sha256 "dd91e030cd402bd53c05793155384fc69c313d2657ba862b9fb14931adf5d4e6"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ecca8d490a15f1e3acde54322905c2ce35af14ce4e4272f2f7000b436e88ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae17b2f14502a9c0f9840b9e547dbf57d17f09ec57b92e3507cdb15d027c77ee"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f4da59a3e66d0662892b1daea8b857ee0af0244907911b45809a337343ccc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdb0d71b57ed1a9d0d12611b5d65f495f8f1e30296b7841752e6ddea332c0b24"
    sha256 cellar: :any_skip_relocation, catalina:       "d67d8980bd97f3f74d308ee00cf115130c69c703068e3e84ac4618249515f30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1d8a91ce9ca01de3a129a83a22f1d42dc708e763509da66cb34204d710bd28"
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
