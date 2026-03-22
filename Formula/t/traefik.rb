class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.11/traefik-v3.6.11.src.tar.gz"
  sha256 "d2dc150e2191ec435f441bfa90b64d603cbb3d886ff2b9a6215f82d0c86af51a"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded97cc5c94da3a789f2b8731307d8ed09511bd4e90b6f4d8c33f47182067d59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3378c9b8ee6b6c7b54fc9338f83e37faa7be633eec06b15f0c5cafff72e848fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b531435a252f7018d4ec686362c6ab4ded8ec292a8e621c9d77d2c278260be66"
    sha256 cellar: :any_skip_relocation, sonoma:        "8870589ed2673ce7fe215ca42a1ba4f0ab28b345c7c64cae9e115d78c3f216f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fde7c98d6241cd52d2c5e321fdff90fca87ac893b451a452fa3621aab9e5e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbccef28df4e06739f36ad2cb8d573d6abc8ee9e341eaf257e960e5a0966d4af"
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
