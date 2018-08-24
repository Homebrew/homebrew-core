class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-3.5.tar.gz"
  sha256 "ba9e1d60a89fd7ed075553b4a2074352902203f7fbd9b65b15048c05f0e3f3be"

  bottle do
    sha256 "36da05b58e05873eec72b04da6bb5e719d26814d8820927bc8684ac680f67587" => :mojave
    sha256 "4533ef4f7200f9fe786332af987740b6db93e9e24b298b32909d9387eb168b3a" => :high_sierra
    sha256 "e14422b545c872c363edc5618c61a2d5772838c54d521c3b2688ac88ed2596d0" => :sierra
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
