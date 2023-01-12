class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.13.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.13.tar.gz"
  sha256 "2079172cce034556f110048e26083ce9bea751f3154b0ad2809751815b11ea9d"
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
    sha256 arm64_ventura:  "67aaca0be0ba780c049ed18599fec3320e6e03be47ebe3d177bbedb1be7f1942"
    sha256 arm64_monterey: "44baf3235d6ab88fbb0df15d8e3cfcae3e9e942367653329a53fe86744085e89"
    sha256 arm64_big_sur:  "7a055c026bcf788f718e2e86a20f4fc32af8003970c188bb39a66165be3fca71"
    sha256 ventura:        "be0b6a5b6be0ba2d11492c8c6f5ad2ce8b721b5ebd264c9f6bbad8cdd58f97fc"
    sha256 monterey:       "81c8e3b9609aef43c10aa9b6d2788f4b89c114a1b05cee9a2feeb859c2582d97"
    sha256 big_sur:        "c02d1eef4cfe9183bb0af84c72154e5f8fbd95868f0b58a9ca19343319ccb438"
    sha256 x86_64_linux:   "f4d085bea730adda5451ba9808485a8d38ffc124dba7cf386f4c819a3e3c0b1c"
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
