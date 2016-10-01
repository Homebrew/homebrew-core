class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "http://ser2net.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-2.10.1.tar.gz"
  sha256 "cee4ad8fb3531281e8761751694dfab39d681022b2363b1edeba764d397c3c99"

  bottle do
    cellar :any_skip_relocation
    sha256 "243a466924f53491468ef67e91f338c7121a74ed79a7f6f604bf188077f368db" => :sierra
    sha256 "6bdf9ae6b2a0ed64555f7e024147dbaab90c13bf15b12e4c6fef0fe37c271a71" => :el_capitan
    sha256 "21ab3a35a22130ac50086dc83e65178ee4c16ea1b1d244f09c971c7f69783c9f" => :yosemite
    sha256 "d6688adab156497c7c3b37f5112e435a9ec27ae91af3af426ff6a1099ad541aa" => :mavericks
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
