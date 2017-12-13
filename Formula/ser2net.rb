class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-3.5.tar.gz"
  sha256 "ba9e1d60a89fd7ed075553b4a2074352902203f7fbd9b65b15048c05f0e3f3be"

  bottle do
    rebuild 1
    sha256 "6cfa743d0e2090bed8f8c2e0495a840dfe77b1f3544582f60a0483315dcfe5ba" => :high_sierra
    sha256 "63b36a1ef39e534d2a8ae91caede4abea2dcfc4ed9ba1ef69f2da6a30baf7b31" => :sierra
    sha256 "5b94f195c765af83306e29f0d8e2556751cbdad1669866761faaeaf199023805" => :el_capitan
  end

  depends_on :macos => :sierra # needs clock_gettime

  def install
    # values.h doesn't exist on macOS
    # https://github.com/cminyard/ser2net/pull/4
    inreplace "readconfig.c", "#include <values.h>", ""

    # Fix etc location
    inreplace ["ser2net.c", "ser2net.8"], "/etc/ser2net.conf", "#{etc}/ser2net.conf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # LIBS is set to "-lpthread -lrt" but librt doesn't exist on macOS
    # https://github.com/cminyard/ser2net/issues/3
    system "make", "install", "LIBS=-lpthread"

    etc.install "ser2net.conf"
  end

  def caveats; <<~EOS
    To configure ser2net, edit the example configuration in #{etc}/ser2net.conf
    EOS
  end

  plist_options :manual => "ser2net -p 12345"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/ser2net</string>
            <string>-p</string>
            <string>12345</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
