class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.10.1.tar.gz"
  sha256 "903353febf1b88f701198d956a60cec3d2be3cc251561a678061761aec6622f6"

  bottle do
    cellar :any
    sha256 "6f729a9e00f72fc4ebad3670eb6e430968c1561a5ea8ece15ecf80e5577864f6" => :catalina
    sha256 "48e80ab7f8caba8de6aeedb36b70d4b29f295b02a376938ac56b20d1aacf080d" => :mojave
    sha256 "726f1d7706922d282315bf895ecc3be79578105261fae9ec16a4be7e552e4d47" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "make", "OPENSSL=#{Formula["openssl@1.1"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  plist_options :manual => "uftpd"

  def plist
    <<~EOS
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
