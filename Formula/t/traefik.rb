class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.5/traefik-v3.7.5.src.tar.gz"
  sha256 "09e44f902945eeced6521c0e561c31c3bdf19f82882945aca049ae31a8e9055d"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7693cce661b41595dcb024ece4441effb86a6b05f21f28bd3bdd717dbb734312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b5c05a28d6accebe92d0c580890b1b28eca525e6311f6e0596a3200217b4d55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e49ed560430f9590b0bab670ec020876c5bf3f2d2c0c62942c0763efc3bacc0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8889558d57a010dd2793f738ea340bebed21aeb03ddff587c27c5db7d9952eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599097a5e18e9a8b9f05cb8c6ee880d0b9dbad95d0193342f1408a228beef30b"
    sha256 cellar: :any,                 x86_64_linux:  "02f06e0c108b26b3de0204909acb8be4d0672f72a5b05e29253f3a2c1e024e90"
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
