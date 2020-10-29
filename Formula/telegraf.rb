class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.16.1.tar.gz"
  sha256 "8da2df0c05032f43a3bed06e333304d81871501737f248da932b92c23fd61ee6"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ed27b3d5e3a9cc9eba7e771ce560f7453db7a38c15d44bb287d6de1c22b2b2ab" => :catalina
    sha256 "e059f56e732042f44ff490baada12baa542f7521845620f5769c80ca833fd17a" => :mojave
    sha256 "f93fbbf78d5555995bc371a12401f30f5c8cd7083e134fe294005fb7301f783e" => :high_sierra
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
