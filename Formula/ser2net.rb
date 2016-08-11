class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "http://ser2net.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-2.10.1.tar.gz"
  sha256 "cee4ad8fb3531281e8761751694dfab39d681022b2363b1edeba764d397c3c99"

  bottle do
    cellar :any_skip_relocation
    sha256 "c36f63357c6bd5c31622ec292ccec85f60ab26f93b5d6930ccfd9052114bc041" => :el_capitan
    sha256 "b9a151626b6634c5c07f1c86371f49911bce18d0d8a9e9e48c5755ad7446a504" => :yosemite
    sha256 "fdca75e5ae2d5afaa17ba6b8214cf5dfe1a52a09e5e07ec6b51eb9d67c254fd1" => :mavericks
  end

  def install
    # Fix etc location
    inreplace ["ser2net.c", "ser2net.8"], "/etc/ser2net.conf", "#{etc}/ser2net.conf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
    etc.install "ser2net.conf"
  end

  def caveats; <<-EOS.undent
    To configure ser2net, edit the example configuration in #{etc}/ser2net.conf
    EOS
  end

  plist_options :manual => "ser2net -p 12345"

  def plist; <<-EOS.undent
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
