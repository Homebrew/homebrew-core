class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.4.0/traefik-v3.4.0.src.tar.gz"
  sha256 "da5dcdbf177c5008a157e4180b039a34a7ad10b710a9ce999545ac86d7c217e4"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfdf40e94efae036cb18be53204ca44f834c3d913b7e3026e5b81f01bf7152d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfdf40e94efae036cb18be53204ca44f834c3d913b7e3026e5b81f01bf7152d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfdf40e94efae036cb18be53204ca44f834c3d913b7e3026e5b81f01bf7152d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "92b3923141d6b69ecfe44145fd51cd522b1a182630c89f0a13be9a04c6a96435"
    sha256 cellar: :any_skip_relocation, ventura:       "92b3923141d6b69ecfe44145fd51cd522b1a182630c89f0a13be9a04c6a96435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0db30024facc7dc7068a0518da9c95f2b86d19480d23bf30d81d627e750fbd8"
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
