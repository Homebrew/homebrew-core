class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.16.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.16.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.16.tar.gz"
  sha256 "6540dd377a120fb8e7d27530aa3b7ff72a0fa5b4f670fe1d64c987c1cfd390cb"
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
    sha256 arm64_sequoia: "1f3a2c7456fac3016ed33c3078243a7c6fa27d94a8122fdb25f6d3a034414a43"
    sha256 arm64_sonoma:  "3a40fae449d8714a2834cf0bad2b2ccf7f7735807323f67d09623e892f414115"
    sha256 arm64_ventura: "0958a6020aeb21f4f133df81c965b95a98ee87504e5d14d1c464010fcde8268e"
    sha256 sonoma:        "2c231639cf6c3eeb57a7b608f363865c0909dd5cc91784e539bc1e9529ffaa7b"
    sha256 ventura:       "639c1761f6c70f16a2a64b6cee766921b3227f9a210afa1e8da235fb9bd2b69a"
    sha256 arm64_linux:   "55af83536eefe0403425adfe9562dd34cadee956553c28514b1741abf23a149f"
    sha256 x86_64_linux:  "19a5400c30b6ba114000c1593b858cb33aad3effe743a42f2537756e0e200934"
  end

  depends_on "pkgconf" => :build
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
    assert_path_exists testpath/"authority_certificate"
    assert_path_exists testpath/"authority_identity_key"
    assert_path_exists testpath/"authority_signing_key"
  end
end
