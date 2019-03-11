class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"
  url "https://github.com/influxdata/telegraf/archive/1.10.0.tar.gz"
  sha256 "83eedb62c771ef3854f79fcd6fbb7ecb4ddabf7b1aa45bcc11e9c6a1f1553ac6"
  head "https://github.com/influxdata/telegraf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f4b5ae93a7100f7a160cad684c01fa143afdac9d43654e6818cca7a56e0ffd9" => :mojave
    sha256 "b7161a0395f0aa2d9e2a82a8ba8d8325363f7774bd83e6b283cc43b0eebf5415" => :high_sierra
    sha256 "b1c2ee6006b583adf740f4bf2833bd70ee6c16f14b1dac1561024d05e14e3879" => :sierra
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
