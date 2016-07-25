class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"

  stable do
    url "https://dist.torproject.org/tor-0.2.7.6.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.7.6.tar.gz"
    sha256 "493a8679f904503048114aca6467faef56861206bab8283d858f37141d95105d"

    # autotools only needed as long as the patch below is applied;
    # remove them when the patch goes away
    depends_on "autoconf" => :build
    depends_on "automake" => :build

    # Fixes build on 10.12
    # https://trac.torproject.org/projects/tor/ticket/17819
    # Applied upstream, will be in the next release.
    patch do
      url "https://trac.torproject.org/projects/tor/raw-attachment/ticket/17819/pthread.diff"
      sha256 "9eb64548f0c1efae28535dcfa4ed19824eccaea1cee62607adb480b99217697b"
    end
  end

  bottle do
    revision 1
    sha256 "6b8355ab0fc0768cc9ae1c17b043355850c83fb297425986e25774cec4d07bc7" => :el_capitan
    sha256 "b34b44ebbbc84d785cb9c9fab6a19006cb2b85160ab45b62ed8d7eef807ac409" => :yosemite
    sha256 "64564813dde75909e57a7a3790694022168104a9c29423822f503c54347c1fa1" => :mavericks
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.8.5-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.8.5-rc.tar.gz"
    version "0.2.8.5-rc"
    sha256 "715c15230f1160c170c61286b02620a1d99a8476dd9c4f80a2e66779be63780a"
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

  plist_options :manual => "tor start"

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
