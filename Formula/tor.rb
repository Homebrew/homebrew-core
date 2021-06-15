class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.6.5.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.6.5.tar.gz"
  sha256 "7b6d354e0d9791eace4b51e92211909308297b7aa257993937163d7ee0694cf9"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "7e729248757a51afab67ffd0ece975e2cfd2c72d19f29e07b1f966e6bb68a27f"
    sha256 big_sur:       "d45fbd9a1f2bd3c4dd59c4c74816040cd5952ef8fa39d9b0777867e1d21bb1fb"
    sha256 catalina:      "caaf2a35e6617f72094351d3945bc118cc7b8000fe3cbf14399efa05d3467eed"
    sha256 mojave:        "252b1de21cf4395e7ec8af17f2f6e28f961ec5b38728e4cd82127873b9212db2"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  plist_options manual: "tor"

  def plist
    <<~EOS
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
    on_macos do
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    end
    on_linux do
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
