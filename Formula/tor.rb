class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.6.10.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.6.10.tar.gz"
  sha256 "94ccd60e04e558f33be73032bc84ea241660f92f58cfb88789bda6893739e31c"
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
    sha256 arm64_monterey: "08bfc322ae48bb84db09a2144970798f5c3bc2272893dfdc5af76f4c58597d73"
    sha256 arm64_big_sur:  "bd2ec2355cc218d2253f5a8db72d4fd7e1bed7e5c8cd0fdb44408585e9d72f86"
    sha256 monterey:       "f516bab5247fdcf8182e7c8c8c7908d2c6c1149c2b2edfabf51e9317a7ef34db"
    sha256 big_sur:        "97e0a400a62090bafb297fe765d4911d8ca6db9d619e63af2e80f9670741b65e"
    sha256 catalina:       "1ae528203260d363d7ce4d0227122fa2cf4816eebdbccb3c7a15a0b226ece73c"
    sha256 x86_64_linux:   "a4b4dd2721cf20bb87ad06bf92806c833019d51db30bcb5fd0ab5986ed9f4126"
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
