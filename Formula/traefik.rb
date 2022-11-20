class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.5/traefik-v2.9.5.src.tar.gz"
  sha256 "6978ce8c08c566a222a44d31817d4f1d93ecddfed753ea5758ce9c30cb151e52"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e872420fd10ee7758ba882fa48b98a367b3431c1581942cf2bcd9d6451a682d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "047d70be07d6d5029b5a0f8a70085fb5270d330f020e3f677ec7461c11ffbc21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc18c657bd4aef7514ae4acaf3b617b2c0919ff1d02cb8a3035c355a633389b"
    sha256 cellar: :any_skip_relocation, ventura:        "3f7157e58a516a10720f6dce4d7c85e40fd650f7549b4c11298c9acb11a6a4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "9722516b167609ef4e59d2d1e70cf6955595f92c5321bd179b95ded045a8a509"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba30dfbb91ca5896a0b4da0bcc1f9fb690f723bfacb22848ba3b90e122c3abaf"
    sha256 cellar: :any_skip_relocation, catalina:       "e10a350d55e05b0bf6d46c54d93ad3435dcad83e567b040cbdff3105425acfbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c74c56e603f489c91e94d6dc85ee181941fb8df790c574a38fb63a033039c3"
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
