class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.3.2/traefik-v3.3.2.src.tar.gz"
  sha256 "9e52bed00308de9fdef5d989ed8ed933a26f69468edad0e270aae147906ab23b"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "669f441fcaf82a28a694794aee43b8bce0dc946503a6704038921a999ce28dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "669f441fcaf82a28a694794aee43b8bce0dc946503a6704038921a999ce28dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "669f441fcaf82a28a694794aee43b8bce0dc946503a6704038921a999ce28dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1313c92dbf3afd5d4a10ea817283c120a544c9ea111714e44459ad0472b5ea6d"
    sha256 cellar: :any_skip_relocation, ventura:       "1313c92dbf3afd5d4a10ea817283c120a544c9ea111714e44459ad0472b5ea6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa266658a989862462955d5edb244841df8c38b21d142f7436f942b46d43281b"
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
