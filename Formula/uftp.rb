class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.4.tar.gz"
  sha256 "17d7d33e90fc4f0779c5a52c693c4f9f02fcbf0efcc7689891800a1eeca1eeda"

  bottle do
    cellar :any
    sha256 "95b11113a4e4bd3f5b01bac7d9d19aad3676efa39c7998be950801a23104cd47" => :high_sierra
    sha256 "2ed1f0e406d7bdaf1049423c6de48034316824b130d46e1fcfab96fb1fe6793f" => :sierra
    sha256 "c49b3cf58a37d51d6a7632a77b420aa7e7a062ced9f8db69a02eb24f7d815a16" => :el_capitan
    sha256 "0552cd9d29e3be5764800da063a14179117bb4f1aecade1ae2ec36fd52a5d7fe" => :yosemite
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
