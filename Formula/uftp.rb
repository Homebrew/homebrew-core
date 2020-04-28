class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.tar.gz"
  sha256 "562f71ea5a24b615eb491f5744bad01e9c2e58244c1d6252d5ae98d320d308e0"

  bottle do
    cellar :any
    sha256 "59b1043904bb54ad6ddd5ec56754ac5c35577ed7fb042e51ef4c962de3dc2366" => :catalina
    sha256 "d21048521221b5a0372c89e58c78b64ebb083a9c107128fff43959c79ef69b08" => :mojave
    sha256 "5b9a00160a6bf9670ae6787060b3fd9265a6f17842e3895ae0b47d1e566efc6d" => :high_sierra
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
