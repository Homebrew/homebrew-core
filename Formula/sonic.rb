class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/v1.3.0.tar.gz"
  sha256 "6f8c1a8779f71bb57978f0baaf65ca65493f4d8a030895b74f579ce2b4e1fa5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "084a2a6ae18232ddcfdbe2a5a28dee53feff5876f1b5c70513cab74956f5fda0" => :catalina
    sha256 "c844ce9bf1a10f0483ef03e8a29d853d200ddf605829418c7246832701695322" => :mojave
    sha256 "72b44c6fd48e1fd331b028a42bb66c030c28f71c09cf9662a987cd021731669a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  plist_options :manual => "sonic -c #{HOMEBREW_PREFIX}/etc/sonic.cfg"

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
