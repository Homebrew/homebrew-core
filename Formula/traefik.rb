class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v2.0.4/traefik-v2.0.4.src.tar.gz"
  version "2.0.4"
  sha256 "bca78975d6a2b6a4683c65d957a5cbed031f34186ac3cc1ec3fbf5303448d2e8"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74bebf524f1b6e4e6b02c0ea237648e52ec5709efc1f7500d3a7e7b0fe03766" => :catalina
    sha256 "dc5c7d9ab88dc3c361359cc7fdbe85977500ee872ce60418008136b61b4c34af" => :mojave
    sha256 "d639fed102b251a131f5fb0b18d020b2c422cac77fc7faef5381bc8ce43adcda" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children

    cd "src/github.com/containous/traefik" do
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "traefik"

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
    require "socket"

    ui_server = TCPServer.new(0)
    http_server = TCPServer.new(0)
    ui_port = ui_server.addr[1]
    http_port = http_server.addr[1]
    ui_server.close
    http_server.close

    (testpath/"traefik.toml").write <<~EOS
      [global]
        checkNewVersion = false
        sendAnonymousUsage = false
      [serversTransport]
        insecureSkipVerify = true
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [log]
        level = "ERROR"
        format = "common"
      [accessLog]
        format = "common"
      [api]
        insecure = true
        dashboard = true
        debug = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_http = "curl -sIm3 -XGET http://localhost:#{http_port}/"
      assert_match /404 Not Found/m, shell_output(cmd_http)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://localhost:#{ui_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd_ui)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
