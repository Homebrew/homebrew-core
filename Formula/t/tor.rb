class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.21.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.21.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.21.tar.gz"
  sha256 "eaf6f5b73091b95576945eade98816ddff7cd005befe4d94718a6f766b840903"
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
    sha256 arm64_tahoe:   "ba9ea9bb2bef46a560913a919f756dd24ada0feb94a371e8139a17d379270ad4"
    sha256 arm64_sequoia: "d79d24f303185dd141800a066bb52b922dbb70f9ac4da35bb3bd811041a9d30b"
    sha256 arm64_sonoma:  "0c62a09b9deb785a64f259b1704ee61543c675970345a9e821cbec9cc1788092"
    sha256 sonoma:        "5e43c013d221c46417706e046ac3b0855a80e7b6fb684ea955a5ae6a132a4047"
    sha256 arm64_linux:   "f379f70443c47e12be9cf71fd978ff57dc179dcf9861e41422f552e79113ef3f"
    sha256 x86_64_linux:  "c3cf2a1ae42dac870f26b603969357cf306de46618ca25f82240c091c7369fd5"
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
