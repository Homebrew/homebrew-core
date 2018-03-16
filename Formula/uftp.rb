class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.5.tar.gz"
  sha256 "83870a5ad05c9e2d18eaa0de7cf43149f489712d8b72a1a00497695881829aaa"

  bottle do
    cellar :any
    sha256 "1cb23384f86d4265575b2f04f4a83bf3702f38197f939aaa29b2f5850c2bb2c1" => :high_sierra
    sha256 "ab7bd052ac6a97f7fbc4eefd86a64759c85cd409988d2cba830d6f3022152b16" => :sierra
    sha256 "224310f641844d95920d4da4b3d09b6c7c7bd7f87a957d7916c20ab2f4a46c0d" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make", "OPENSSL=#{Formula["openssl"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  plist_options :manual => "uftpd"

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
        <string>#{opt_sbin}/uftpd</string>
        <string>-d</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/uftp_keymgt"
  end
end
