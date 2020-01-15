class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"
  url "https://github.com/influxdata/telegraf/archive/1.13.1.tar.gz"
  sha256 "5c7924eef1dd5f042e567e654c57a5271dcc9f4ebbeea79adb9c29599c802c84"
  head "https://github.com/influxdata/telegraf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "633be9eaaaf1d5a7154e5bd7fb542e357d96403ae0a89f1583035afd4e5e14e9" => :catalina
    sha256 "3e966310f6d832afc00dd9a82de27d6425e1e88da773b1b46bd258a9936bd7d3" => :mojave
    sha256 "41dc50579ba43013c847c1524d13d0004ea4217bb6807ea404e8b1d2b5d1d5a8" => :high_sierra
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
