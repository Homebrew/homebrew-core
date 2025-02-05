class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.14.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.14.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.14.tar.gz"
  sha256 "5047e1ded12d9aac4eb858f7634a627714dd58ce99053d517691a4b304a66d10"
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
    sha256 arm64_sequoia: "9725742a32a1aa38bfc31aa70a24106769fda973a8a90828ff9e06576e6746bc"
    sha256 arm64_sonoma:  "f34c230592b448359282401430f14aad18abd80091c8a718bf202502daf5a235"
    sha256 arm64_ventura: "1272b89435c1e980eeb9cca223c250a58406f33d70d093a5692cea13ab078d2c"
    sha256 sonoma:        "ab8a098eeff29db5fb001192eecca892558b779f8bbd483d9b70bbf9d95820b5"
    sha256 ventura:       "c0355dbfbbc25a1fc0732c37a2c36383fc6f1adc7f6744c509d80d5ebb98f802"
    sha256 x86_64_linux:  "174b6eb695a34a59ce41225a2e75d1749d9006b39be560e36a86dd850ccf159c"
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
