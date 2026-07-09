class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.7/traefik-v3.7.7.src.tar.gz"
  sha256 "3c132806eddbe1dc894e7341dda05beb50936688b9e558b00c3a35dc300d353a"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2149d249a9485740de6bf39d6c32a9dec379a506fbb0709a649058ae28d150b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e951a152331fa4fc844e243a4e5dceb45dc909cd4faa6628c2aa53b9f250dc50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8625f43b87c19ba7922361401cfce88d3148c4a016031b19da59a780ff890fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a429b1837131467c0ee70f5241f7a270767b5be18e61b28c6dfea4a933d2acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a2a8541df0868dd4aa7c3ccf9c8078ad5f89ee263882483f76f199b79c1ff15"
    sha256 cellar: :any,                 x86_64_linux:  "83477052941402750e38f5e29c8f91730dde9920c9a14ae8aee5a206e09b094b"
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
