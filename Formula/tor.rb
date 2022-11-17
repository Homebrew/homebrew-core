class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.11.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.11.tar.gz"
  sha256 "cf3cafbeedbdbc5fd1c0540e74d6d10a005eadff929098393815f867e32a136e"
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
    sha256 arm64_ventura:  "5e41168f2e715e7c34bd9c6972ff12769737cea05045141567e7f495cc00e256"
    sha256 arm64_monterey: "edb20155a92e83f4afd624c2ab1fbf74e288f585a11f4ff65a4bc1e0a9ec6838"
    sha256 arm64_big_sur:  "1a87db73b87298f79be8137548928eebdcababeb4952310b74e3d0079d7d037d"
    sha256 ventura:        "d9d8cfde5c830812421e0d1f109c22125ee1f4269f8461a2105f52fb5f70f17f"
    sha256 monterey:       "ace512dc7728847bd350b624073390dbc45c88a77041523d9a835f6d0c705cb7"
    sha256 big_sur:        "bdfb36f584a647db41e4fb1e1a5b6186d25551f89467bddd2a350f1fb7e800b8"
    sha256 catalina:       "c785ce048594262e9f5306a0403e1c3358da63b438ab4273dbd2adc2a1fcb1ed"
    sha256 x86_64_linux:   "88feb8daf13355e567617c86bdc3760599c944c0280250a9f8b405a2d1bd33e2"
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

  service do
    run opt_bin/"tor"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tor.log"
    error_log_path var/"log/tor.log"
  end

  test do
    if OS.mac?
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    else
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
