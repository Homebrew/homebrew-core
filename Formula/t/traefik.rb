class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.7.4/traefik-v3.7.4.src.tar.gz"
  sha256 "2f8bad4c4ce25820354702647b2b57e4f6c7b21d801a6ad163c7fc9cfa9a2491"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ea77a212425b9a33c40b8c3c6d17c150b21606e72bba8cde0d2b772089f4c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611e25d4c641c4072c14499dfa24585015f82a082caa5b39323c112360b882d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ec4fce58eb7dcadf6357aae6518ffc818f4ccb49218957063a8fb068422437"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ebe5f702d1c8e321b6d68a7773b39d83d0d59fab4da20f01c945b49d41aa6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04329cad645572d69d3e7e57529f1c9a5117e737512e49ffce99b9fad95ad972"
    sha256 cellar: :any,                 x86_64_linux:  "35d4113e1a2ee069e8ffbd8fdeecd95b3e8d7c2c17179f678057fc4d842cd72f"
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
