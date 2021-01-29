class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://www.influxdata.com/"
  url "https://github.com/influxdata/telegraf/archive/v1.17.2.tar.gz"
  sha256 "3de026754bc543f136c58175ceef8a12688ea3e1903bbc89c4a76aaf97f6d8f3"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "037f79e3380033c60221594b786f0dbb14cc0e6a89b8d32a2ca17c2f4b58322f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b711e6cadca00263ac6bdb31593c8bfe356754b9b7f5cc1d5c20c3a64e6cdce8"
    sha256 cellar: :any_skip_relocation, catalina: "ae8daa85a076f461d9f4ac3e7b913439dfc1114ca542e50221dc609a6b6607c2"
    sha256 cellar: :any_skip_relocation, mojave: "8a1c7065b0a0143faff9a94c54e58cc69407aa4e88ca7c20680d1d956fc62286"
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
