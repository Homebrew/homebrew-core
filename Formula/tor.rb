class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.0.6.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.0.6.tar.gz"
  sha256 "a3e512e93cb555601fd207d914d7c5fe981d66d6ebb5821ecdf5dea738c2fb14"

  bottle do
    sha256 "16237392bef04e8f4857f6a76d10842676732b80e2d3d9e184f14f572e7b457c" => :sierra
    sha256 "d553869d5a12c5d8cdb8d7db30d8c0b3f11be9a6efdcf51a7cca7088b9f34d49" => :el_capitan
    sha256 "9bc64bf56797221ebce23972c908565399995058f2db6ba05c4a3ea26b61e3d0" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.0.5-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.0.5-rc.tar.gz"
    sha256 "622c9366d8b753da9192e037d0a13d2d87ffec25b5c606a3d73a2452976b43e0"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"
  depends_on "libscrypt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-libscrypt" if build.without? "libscrypt"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "tor"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tor.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    assert (testpath/"authority_certificate").exist?
    assert (testpath/"authority_signing_key").exist?
    assert (testpath/"authority_identity_key").exist?
  end
end
