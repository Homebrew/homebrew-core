class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.9.1/traefik-v2.9.1.src.tar.gz"
  sha256 "dd91e030cd402bd53c05793155384fc69c313d2657ba862b9fb14931adf5d4e6"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d3141047264bafea6c718fe5973afbe9e291dd9b27636c02b1452772e0add9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72b783dddc12ddcc572eb93baa72f0569a3ec93d045a3160406d97e3a47ab646"
    sha256 cellar: :any_skip_relocation, monterey:       "947f88bb955ed75527306ab98bb5ea5b645ad67094649e225ff8b0253d60175c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c9af7a4d431a4abc70af4aed4c8c3775ac7b96eaabab41133c842fe23e3a680"
    sha256 cellar: :any_skip_relocation, catalina:       "23004bc6edbd158f4fd12c0f1b1a682f127db599ad23a5094406b3366ca39d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533ad6032ad106bcc6c2a508e28e695bee4ac649d059b199d02be52bea53ef08"
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
