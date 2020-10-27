class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.0.tar.gz"
  sha256 "6f8c1a8779f71bb57978f0baaf65ca65493f4d8a030895b74f579ce2b4e1fa5e"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d22157b31f471d3b5a74018cef0fbcb5c5b6cf4f2a59df7b3cfe315090d3d3b4" => :catalina
    sha256 "5e68bc4761ff25830382fe068ef89a38c71762f98958cf1b7f3dc1db8dc7cc26" => :mojave
    sha256 "184bf1ac4972c580d1a648f48a4aa6f01fecdc1aeefb2cd0bb6789232fc2ba22" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  plist_options manual: "sonic -c #{HOMEBREW_PREFIX}/etc/sonic.cfg"

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
            <string>#{opt_bin}/sonic</string>
            <string>-c</string>
            <string>#{etc}/sonic.cfg</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/sonic.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/sonic.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", ":1491", ":#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    fork { exec bin/"sonic" }
    sleep 2
    system "nc", "-z", "localhost", port
  end
end
