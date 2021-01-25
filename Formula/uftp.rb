class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.tar.gz"
  sha256 "562f71ea5a24b615eb491f5744bad01e9c2e58244c1d6252d5ae98d320d308e0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "8bb1c997a162785aae612d640fb4e9a69c22af980b38d82484b899041c024f1b" => :big_sur
    sha256 "b38ccf77d80d8b662c86abd4c11b3c94e6a1a166b011392f16261289ebb1d923" => :arm64_big_sur
    sha256 "9a5f0d2a7fd5887a164733d78a5d57ded16f398284d58b258ca7221f3e5287e6" => :catalina
    sha256 "7193614091b37c59942a9d0cdf0cca676083b83062cc3db48c15a097734cc1d3" => :mojave
  end

  depends_on "openssl@1.1"

  def install
    system "make", "OPENSSL=#{Formula["openssl@1.1"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  plist_options manual: "uftpd"

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
          <string>#{opt_bin}/uftpd</string>
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
