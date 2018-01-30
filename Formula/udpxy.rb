class Udpxy < Formula
  desc "UDP-to-HTTP multicast traffic relay daemon"
  homepage "http://www.udpxy.com/"
  url "http://www.udpxy.com/download/1_23/udpxy.1.0.23-12-prod.tar.gz"
  mirror "https://fossies.org/linux/www/udpxy.1.0.23-12-prod.tar.gz"
  version "1.0.23-12"
  sha256 "16bdc8fb22f7659e0427e53567dc3e56900339da261199b3d00104d699f7e94c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "485d6e3879f7c6c6b7f044993ea141cde309f5f3283688b795a21276d5daf754" => :high_sierra
    sha256 "856dd5abfc350e8ce06e361664c21732e0b11dfd84aca7f9bd1e0e40704ccb67" => :sierra
    sha256 "6f2fb0a9baf932d599fca41b8ec80cd35491332ab89464bdda6d7ac8e5b5e01d" => :el_capitan
    sha256 "7624631dffaa797191689b05fcb5d7c87c0ad233e49c308b10462c08c8a955e4" => :yosemite
    sha256 "45dcc2c1a7d1f0170ae44edf600fee1f6112fd1e11530548a7e3b1870d71a7d8" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=''"
  end

  plist_options :manual => "udpxy -p 4022"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/udpxy</string>
        <string>-p</string>
        <string>4022</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end
end
