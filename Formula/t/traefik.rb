class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.8/traefik-v3.7.8.src.tar.gz"
  sha256 "3a725c0ead27fa512756acd57056ec4652420a9daceaa6d9c170bfbb25bf51f9"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60d9e140dc5531e8c2a994f3bca68e34a890b4f08382d698883d1bc7813c85bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87afabf427406e314c95aa1e8a1d1c74cd4539db1b186d414e7a58e59f97b659"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8721d4a18abf33706b1c3eee00a2aed191939519b689246d0f588d32bbbdc994"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a6bd29064ccba66a4b94621913a78c656a693b8919df883afff76dd65ccf4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42958f44fdbcb8455ed37eaa3e22d677280975d1e5c071e2d529dbd91bcd857a"
    sha256 cellar: :any,                 x86_64_linux:  "6e63261e89a2044b38f6d880fa84415919238a923eb47829aa90d230428f3977"
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
