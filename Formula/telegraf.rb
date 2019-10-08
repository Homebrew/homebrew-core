class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"
  url "https://github.com/influxdata/telegraf/archive/1.12.3.tar.gz"
  sha256 "8799b0e2a16a9efb3a85271fedda0b6fd9b5110ce51963688273e60b80bc9aa1"
  head "https://github.com/influxdata/telegraf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a1131344686b1b5f34a9011ee4bc7c9073d55988f14690424d4d14b282e6520" => :catalina
    sha256 "9e7b66e7c98d568a531ace9920dc6617d701f8147c68e92deb3fd68ca963ed0b" => :mojave
    sha256 "d237b753e4f8e2a8ba21016c80289e6ab712c0ee275fe7d7d0a7b87c5b279dc8" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/influxdata/telegraf"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "install", "-ldflags", "-X main.version=#{version}", "./..."
      prefix.install_metafiles
    end
    bin.install "bin/telegraf"
    etc.install dir/"etc/telegraf.conf" => "telegraf.conf"
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  plist_options :manual => "telegraf -config #{HOMEBREW_PREFIX}/etc/telegraf.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/telegraf</string>
          <string>-config</string>
          <string>#{etc}/telegraf.conf</string>
          <string>-config-directory</string>
          <string>#{etc}/telegraf.d</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/telegraf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/telegraf.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
