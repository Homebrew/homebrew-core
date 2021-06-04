class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v1.7.30/traefik-v1.7.30.src.tar.gz"
  sha256 "021e00c5ca1138b31330bab83db0b79fa89078b074f0120faba90e5f173104db"
  license "MIT"

  livecheck do
    url "https://github.com/traefik/traefik.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a1dfc827581dc524c337537f65ab76d632447b2f058701011f2d50ca2d55f26"
    sha256 cellar: :any_skip_relocation, big_sur:       "6733a3982d2031a5a0e647c50b6fe0e6f1ed18441102cc89d245c943f179c373"
    sha256 cellar: :any_skip_relocation, catalina:      "9fed988a2abc60ec1022d504707c8b64bd9f73551a8f0698c4663669b153ddb4"
    sha256 cellar: :any_skip_relocation, mojave:        "fbafd58e2104c0d4faa60784f0827cb891be4464ec9c86837f804937ac66a2c0"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/traefik/traefik").install buildpath.children

    cd "src/github.com/traefik/traefik" do
      cd "webui" do
        system "yarn", "upgrade"
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
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
    web_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [web]
        address = ":#{web_port}"
      [entryPoints.http]
        address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd)
      sleep 1
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
