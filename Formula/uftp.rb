class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.10.tar.gz"
  sha256 "91ba8aae80c7c9ccaf04600b628cbeca4699ed48268fe43d2bf539a41083f292"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7a3fba8e55b2dc2eed95d3922ee849b158c97eb65b5bcd333d5b70bdaa198f51" => :mojave
    sha256 "2a9dca5eeafa7a9b3ecc2fbe989e107dcc88609529e298c903a1cbdfc4cfeb76" => :high_sierra
    sha256 "a8f42a5f05adb4566f7179c2798f2e93b46f937508fa70f1d91cb8d192096765" => :sierra
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
