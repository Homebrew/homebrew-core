class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.7.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.7.tar.gz"
  sha256 "b20d2b9c74db28a00c07f090ee5b0241b2b684f3afdecccc6b8008931c557491"
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
    sha256 arm64_ventura:  "c5bdda5ba6b629469c2a3308e18d0fc175c265f304d4a9b371b82330084c768b"
    sha256 arm64_monterey: "41d8fdf807b87fe7e1bea3b5d53f9cc6c413f75d2d824a01f42da9c1165bb436"
    sha256 ventura:        "467584b0e3acbac8a5991baac783953bc83048365c22fa947d4c8080a48bf504"
    sha256 monterey:       "38232cddee46344bba00e95f053b8ddc2d4c47281112c705e790f9d0c47f4a1f"
    sha256 x86_64_linux:   "42d5b710bbc46f8bd5f9c4a7ec5fa52452d3402ac045fabd135981d2e4c055d1"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
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
