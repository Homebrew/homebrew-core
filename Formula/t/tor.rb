class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.17.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.17.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.17.tar.gz"
  sha256 "79b4725e1d4b887b9e68fd09b0d2243777d5ce3cd471e538583bcf6f9d8cdb56"
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
    sha256 arm64_sequoia: "a6f65834822866ff7d788511eba6c0303ef2df4a0c142bf09248dc63db35dda6"
    sha256 arm64_sonoma:  "f618bfffa5cf93e615e05f94410eec96b273ac2c7b13122c3e75f82884b60b13"
    sha256 arm64_ventura: "5b5fd93fae21d1abb7db73aa53cdaa7a42c2cbb74f6b1be1448bbf418bb38810"
    sha256 sonoma:        "54d850a0d1d3c84986629e5d7188f056439970baf9bb6c9c56f3afa08fbadc24"
    sha256 ventura:       "7d210c8357df329a586b5cd07855ab58e5faa856a9b7e65a05e722fd5c61ee4b"
    sha256 arm64_linux:   "257516ec147efdc3fe22f77439f6d6480fdf654035c36d190862f6f1b16dde56"
    sha256 x86_64_linux:  "6a771c77aac582e739089c0e54769f2b91545e7f388d46c76fb47b81f89a9458"
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
