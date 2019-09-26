class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v2.0.1/traefik-v2.0.1.src.tar.gz"
  version "2.0.1"
  sha256 "5f0101f5cec6c132f612083d4e4307050fbdcf9cdf4c8059fcc1ea9e5148063e"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b81b90fb51528834b5fb5afb4904361cb0d8d549fc76b5db53821a1f22be47a2" => :mojave
    sha256 "758c4ec5e25d5f241d23a26cc425c44a9e9c64c011feb55fb2140ed4c98cf0b9" => :high_sierra
    sha256 "615828f922b3daed414965e2db13f6adc56af3d9f3a65ad26d697e75410dc125" => :sierra
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
