class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.13/traefik-v3.7.13.src.tar.gz"
  sha256 "a4c57bb9b68514075dd849f79354cf9c4b860be9330ece85ac8dad5372b82444"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c09aa1d954c90a267afb66bad488ec5bf992f75577178adb54b11d978d1e227"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a915275b672dd65fcb32892f783d9ceacbb87ee31a233fc13df3daf99929f03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c9ed9d3906c1b315b75abfed6b2324b8e016c3bd1db8451fc90f4c918f2548e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "726b9f73a1c44d76a9b6f6398b047581d75892430bd50d6f6b74ae13e131297a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3284fac7d0d44bc17bb46bdbc3210bacbca4a8070a244fa28f2daa00dec4b922"
    sha256 cellar: :any,                 x86_64_linux:      "5025b8600045c541f5a4f29e680adb06b66c67455f7437a1a2fdb4d461ff77f8"
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
