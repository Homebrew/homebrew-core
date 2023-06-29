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
  revision 1

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6c9a74d4b68b89cb2d38990d9ccece504e6850449e5f5c63dbc9d32160db73fc"
    sha256 arm64_monterey: "e5ad8cdc670fcde5068bcb4cea55e6d67d0d91a0d9410df85739b2da879505e5"
    sha256 arm64_big_sur:  "8ec634a8d1c1ae5b624c9c61a82c2998b2363f4c1eb752b9a18b5c2f8495673d"
    sha256 ventura:        "9579051e421477496c152189f2e12d745c2f733d601829e8f102c47ecf7a0c28"
    sha256 monterey:       "b27824ccd356e196e05d9e2b86b51cbe7da7bad1590642b5fc089c1cca40771a"
    sha256 big_sur:        "3ef4e57343bc77e5c0ee90d462a530af990e733b549fe364a8d23efd17816bef"
    sha256 x86_64_linux:   "def66394b80ea1d4090c7d9c373eff46238bcec9f79a3ea033bc3ecc3ad4f89b"
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
