class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.19.2.tar.gz"
  sha256 "a92de0b9b30d6dd4348ea5b05c0883d95149afb4add452a249e1fbe903025dd9"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b97835d69f3707a8ef8487956a532aa30bb6a21df51459d9217ec0a77b75c41"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed9f54a587013dbd7456a2e55064c430c54408a68eb0f1eec12ec208f60a61e9"
    sha256 cellar: :any_skip_relocation, catalina:      "ab7ae20fac972decc511817f5ecc92a02900aec7cdb022cfbdcfd489bf2f19c1"
    sha256 cellar: :any_skip_relocation, mojave:        "2a9a3c8bb280d81397db7cd0f95dda3019c7852e6c55699385b37f7774802299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb10fa9d3cb5ca9aa95a7a1396ecdbf52ef929e54abc893c63cb808e2460fac"
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
