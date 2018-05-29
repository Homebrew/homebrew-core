class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.7.tar.gz"
  sha256 "c8bed420e6bd2b539f42f92b5ea0876c4a0ea512bd5c076507c9c066d8fd01be"

  bottle do
    cellar :any
    sha256 "daee417f3a56167dc5a40341c510119d1bc5af8daba600ad02d2d25afcb9fa0f" => :high_sierra
    sha256 "662cb4503e70bb2a3e369f4f012e0f96ecff7a7f6d929aa2a8080524b95a9f51" => :sierra
    sha256 "723329b24e43142966981c56d6bc843f228fe1504171afdd9425e50d26b9a22e" => :el_capitan
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
