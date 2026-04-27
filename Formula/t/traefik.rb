class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.14/traefik-v3.6.14.src.tar.gz"
  sha256 "c7874ff6e7ab290b8391e675a2a3b889be85899978adbb8f0c804a1baf888f18"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb5c9d9103e4bd331e4af97715d4280434e41bca65e8df81c28a9760aacf8774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71632c962306f8574dd4bf3c33152f1fb24c1c040a09f813c0a29cf46a749ff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a9efeda3f7081ca82037ac66336a9b23dd75588e2e0ad4bb45cbe38b4d08af"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf998d3b98b7e7db0ae91eb8cdeb8b81c445261a9d307a00e32776dfd6ad891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1230786d6b2b7ea0be3c0155a63fa73a922c5fc4eb34fd9a71ad40d36f79c366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11078abcb1c9f8de2814d2e87069c016068f705d1503b56f3dc3623f4a8b6075"
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

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
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
