class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.9.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.9.9.tar.gz"
  sha256 "33325d2b250fd047ba2ddc5d11c2190c4e2951f4b03ec48ebd8bf0666e990d43"

  bottle do
    sha256 "f2be7a1530fc41446f493494c605a11389387f6d78e12add1ba80129f930331c" => :sierra
    sha256 "d8ea3d5a71881be83aa7813dec88066ebbeaacc0f59cd502592946f0337d775b" => :el_capitan
    sha256 "efe122e86900876ea283fc0109dc701c74bb2c58335f4f10afdfeb1be9fc9620" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.0.2-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.0.2-alpha.tar.gz"
    sha256 "736f135ab2b6473ccbeb454a845451555a99d72b4c6015e77c7689392bfec17c"
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

  def caveats; <<-EOS.undent
    You will find a sample `torrc` file in #{etc}/tor.
    It is advisable to edit the sample `torrc` to suit
    your own security needs:
      https://www.torproject.org/docs/faq#torrc
    After editing the `torrc` you need to restart tor.
    EOS
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
