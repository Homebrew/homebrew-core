class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.4.tar.gz"
  sha256 "17d7d33e90fc4f0779c5a52c693c4f9f02fcbf0efcc7689891800a1eeca1eeda"

  bottle do
    cellar :any
    sha256 "a3293a806be81f2317fa0cef56c72e1a3661822414d7687d2cc00598a5a2fbd7" => :high_sierra
    sha256 "5eaad736c42e840f384b205cbdbbb8704be1cc7e7d05bcc06f89cc0f5d34fc76" => :sierra
    sha256 "2c28f6ae8821838b596cf31f8011a321be0ecc0a47a9ee9b56fab4357d702877" => :el_capitan
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
