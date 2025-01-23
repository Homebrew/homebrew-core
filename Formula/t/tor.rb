class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.13.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.13.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.13.tar.gz"
  sha256 "9baf26c387a2820b3942da572146e6eb77c2bc66862af6297cd02a074e6fba28"
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
    sha256 arm64_sequoia: "c145702b169716f2d3945258a78609fdcddacddaea2bff154adc8a2599cc3252"
    sha256 arm64_sonoma:  "c3ba7457be7ade66fbdd9183e0ea1af569095bc74a9760d91fdefb2b80f168e8"
    sha256 arm64_ventura: "a3941a78504ade9acf7cd5b5311faee1ace9a6b2d7d36cfd32e2ef6aeccc6124"
    sha256 sonoma:        "5372b93592b6d2306c2003acdc75001fcc6de1b606bc11b2bfe64e7aebbf2271"
    sha256 ventura:       "4355e3f8d810a967daf2e76dcaf8929e0d1951d8dcfcaa9affd0dd6ce0e760d9"
    sha256 x86_64_linux:  "61c54b14efec65e0f0cb97832e78a1740453859421769d2478f18e7a1ee6978b"
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
