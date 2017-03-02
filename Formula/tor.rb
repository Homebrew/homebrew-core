class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.9.10.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.9.10.tar.gz"
  sha256 "d611283e1fb284b5f884f8c07e7d3151016851848304f56cfdf3be2a88bd1341"

  bottle do
    sha256 "039e0f836cffc1324b4f3274c146ecb98d708b8dc11b87e09486629b748ca67e" => :sierra
    sha256 "4d0697da1e43c6655b45bfde0e7a148cc3ef375bcb6327a93dfc0b49732fce40" => :el_capitan
    sha256 "eff4b82832aff93b37bf3b488bcf616eb0186f5f4caeee5ace5e7a19eb488830" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.0.4-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.0.4-rc.tar.gz"
    sha256 "32a7c0b322c61e15ce770f43715682f8b0be47844478387ddf8444cdf7c2f46f"
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
