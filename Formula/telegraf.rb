class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.15.2.tar.gz"
  sha256 "2cc5392e9b035bce3255693b718d9e4bdd54fe16f5dc728b933113cfdaa93360"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7df245171b2f9b7791e86e21496494f1a31fa38e77ba5c97d656d6c0df82a820" => :catalina
    sha256 "358500c7190955a7f471070d91063bc89a1d9ed0b9978c066264ca05ea082903" => :mojave
    sha256 "194c317ad592aaa314ff28bf4751352093922835ecf2b651771e480351bf2369" => :high_sierra
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
