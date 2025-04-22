class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.3.6/traefik-v3.3.6.src.tar.gz"
  sha256 "4599ac93dc97bfc2ab38d0d56971c19f700614024d2c2e5b3ef5c28f45954d00"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0d27cbedf1ff78c994bd89238015fec8c4a94c73782502a7b51ec0d791c003"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f0d27cbedf1ff78c994bd89238015fec8c4a94c73782502a7b51ec0d791c003"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f0d27cbedf1ff78c994bd89238015fec8c4a94c73782502a7b51ec0d791c003"
    sha256 cellar: :any_skip_relocation, sonoma:        "57ed447a1dd4ba124fdb89071a12e2b3a31f5f094c84172d218a57c1093d1b0b"
    sha256 cellar: :any_skip_relocation, ventura:       "57ed447a1dd4ba124fdb89071a12e2b3a31f5f094c84172d218a57c1093d1b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c6c5ada32a959b9c1f11554a2131eb0afb182209f08aeddaf9d5a86348b861"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    cd "webui" do
      system "yarn", "install", "--immutable"
      system "yarn", "build"
    end
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
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

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
