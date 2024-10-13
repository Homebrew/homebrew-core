class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.12.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.12.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.12.tar.gz"
  sha256 "ca7cc735d98e3747b58f2f3cc14f804dd789fa0fb333a84dcb6bd70adbb8c874"
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
    sha256 arm64_sequoia:  "5f471c9b29171f938f84bec857248b00f60a52a9a285eb470bb7f4dd2a401959"
    sha256 arm64_sonoma:   "08619f6e0f621afa6eb43c65c0ac4ffaa31568f89dfa428afd467b1a55eb9a6f"
    sha256 arm64_ventura:  "c69f50f0e4607d5c0e2ce6e8360370d23a7d27247fd59303c5bdea52d0c263e6"
    sha256 arm64_monterey: "ede75266f6688ec46c38caeab8c6a1fb0e4dd0bbbbe102813256afc98f2d545c"
    sha256 sonoma:         "d890388b853cf2bf5b5f8ace59b1e536e0bee8a25b6ad7a51d1fb9090da29cf0"
    sha256 ventura:        "bf5aec6c7472b065f01f6ebc4566e5317f2a0e882428a0bf443e5871523ce583"
    sha256 monterey:       "dba1976ae5d9556c3756a0cfea1581b370c11d92805d19d8a07724a537bf7cc0"
    sha256 x86_64_linux:   "731735eab74edb5048994957d64222b39323d1e03cc122cafa74f7670555b72b"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
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
    pipe_output("#{bin}/tor-gencert --create-identity-key --passphrase-fd 0")
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
  end
end
