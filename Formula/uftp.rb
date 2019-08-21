class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-4.10.tar.gz"
  sha256 "91ba8aae80c7c9ccaf04600b628cbeca4699ed48268fe43d2bf539a41083f292"

  bottle do
    cellar :any
    sha256 "adfe50e724e71c21e9923b0c0ff6021b7617a9a8ddf08250b3c4d32bd832b317" => :mojave
    sha256 "af750525b63ab15ecf7595e6d1f8026431a7664ce3d9e1625f30106dca109c27" => :high_sierra
    sha256 "f07b4b2fef5ad1d292c7e54591ac2ba3a99625483621ad0154907c28ed79cf08" => :sierra
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
