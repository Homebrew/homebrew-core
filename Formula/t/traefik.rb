class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.19/traefik-v3.7.19.src.tar.gz"
  sha256 "94212099d79321aa28b8cf44a69dab0e54b008518d65356dc1db294554edabde"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0e72949f9156b0fde80ed678940728844a79b3bd20be8241f3ab2bc09fb6354"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1dd3e6d16fb10ae702168776b67389201520977f47fa4773065bd114f319b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c23f724dbf66850f05ff273a31a5fbd39a22302d8658a4e210d406aae6567d42"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0e72d1c322e92223d5f0c687110cb23022373dd40f95b6af17e8691fd6a9e93"
    sha256 cellar: :any,                 x86_64_linux:      "bc5637be29e4f21c941edbd61fbf7e5d168616855a43449f2455cf024107d7e2"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[-X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}]
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
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
