class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.6.8.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.6.8.tar.gz"
  sha256 "15ce1a37b4cc175b07761e00acdcfa2c08f0d23d6c3ab9c97c464bd38cc5476a"
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
    sha256 arm64_monterey: "c3762e94997d6b6f2ecb16aacc3764737b766e29f919803d3e53922d8742bbcb"
    sha256 arm64_big_sur:  "efc314a687bb144fd4a655c7c9555d7688071749c2ceacb758c103cc30125b49"
    sha256 monterey:       "90e8e0f7e240541020b1d425ba7ea312ca7f5c7721813396fcb151c57777d1d0"
    sha256 big_sur:        "d075f702a798d00bed7bdfeead10ec0e6ef2be5953f7e62382840cd0eefab7d5"
    sha256 catalina:       "d797c5390176cac9edbc7df042fa3421dc93dca3f291fa2340d37c97292c6d00"
    sha256 x86_64_linux:   "34220f2e859a6d3d22f47a59fb4134d28ffe3c0b50b5d0badb8d217e70bbd167"
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
