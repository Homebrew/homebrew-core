class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.8.tar.gz"
  sha256 "e98c6318e497124d777ca71eae752d213207c35de9f782c8bcaaf82ece20e599"

  bottle do
    cellar :any
    sha256 "1e9cf93c7cf204be2c2fa257321adc3c561e38f2232b1cb730d1b7afe246dabb" => :mojave
    sha256 "69cc89d4b25477b115b242297b7c2ea4385a2097870d433b344e36333e874a9c" => :high_sierra
    sha256 "8df58014e1e469d45a7f703387464a31663f0d632693b906fee835179000f95f" => :sierra
    sha256 "b59605f65f2224aab208aaeac7867d25a05c8abe92afe8aff6a71a60a1e9e297" => :el_capitan
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
