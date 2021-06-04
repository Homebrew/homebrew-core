class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.18.3.tar.gz"
  sha256 "877496fb440d9d18713cafc01df8e24c0b1cfd5945f5a5c6cf5fb0df62b0f2c3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f5b9309ea51896f87d6c1a6a6e814b55b884a8897b03a3cd4d6c625e929ca95"
    sha256 cellar: :any_skip_relocation, big_sur:       "eadb472bc52fc0120f6434e39be898618e8145c5124d850a22054dec06c9498f"
    sha256 cellar: :any_skip_relocation, catalina:      "8fe77dc3d8535ef1a3694992fc5dee8d123b54a625d37f6963bbcf48ea4fbc6d"
    sha256 cellar: :any_skip_relocation, mojave:        "a871037d00ea75cc4fd0114c2eeccaf93d316d9939744bf7e0a79af57cddff74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}", "./cmd/telegraf"
    etc.install "etc/telegraf.conf" => "telegraf.conf"
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  plist_options manual: "telegraf -config #{HOMEBREW_PREFIX}/etc/telegraf.conf"

  def plist
    <<~EOS
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
