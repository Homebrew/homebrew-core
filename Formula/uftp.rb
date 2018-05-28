class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.9.7.tar.gz"
  sha256 "c8bed420e6bd2b539f42f92b5ea0876c4a0ea512bd5c076507c9c066d8fd01be"

  bottle do
    cellar :any
    sha256 "62519412679c2827daad4c60a524515af4c137f3445d2891d97f3b57f98806a5" => :high_sierra
    sha256 "b670abbf7c7e885cd59f2c4a79531e43d4acdc25dbdbc6fb641ad5db6c91cbef" => :sierra
    sha256 "9f1dc36bee2fcf4e0f67b33d4075cb3c7bc360fd577cff00c35ac771d5a53bc7" => :el_capitan
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
