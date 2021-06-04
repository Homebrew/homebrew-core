class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v2.4.8/traefik-v2.4.8.src.tar.gz"
  sha256 "874d22a52b7541b5155db675562ab5db3c99d2530633de3a058c4ae6125c86d1"
  license "MIT"
  head "https://github.com/traefik/traefik.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aab8b6652d689778ea2287f71d6468ee12370d41431a6be8345730190098c134"
    sha256 cellar: :any_skip_relocation, big_sur:       "355e8e863ca704a2f40df2c8ac860add614fd1b970780c14be539d1742f03fd0"
    sha256 cellar: :any_skip_relocation, catalina:      "2e152ebea4b1f2b2f477e8506cecd36fc7d7fc2e3274d72e50c6a3fecc5d4c95"
    sha256 cellar: :any_skip_relocation, mojave:        "bdf8a9e69a5537ecf156f64a957c4b0784798db2efbf61a11c8574b4d886506d"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go", "generate"
    system "go", "build",
      "-ldflags", "-s -w -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}",
      "-trimpath", "-o", bin/"traefik", "./cmd/traefik"
  end

  plist_options manual: "traefik"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/traefik</string>
            <string>--configfile=#{etc/"traefik/traefik.toml"}</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/traefik.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/traefik.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
