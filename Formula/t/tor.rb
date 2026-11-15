class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.17.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.17.tar.gz"
  sha256 "ff372c41ee7013557fe5b7acd96c909950b27a7959c59fcb87c02591682fabe2"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]
  compatibility_version 1

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6a2c803b6dc0bfdf4596e9d7a53e9bafc5a46a1fe6a92deaa7e5f0de7dbeb9d2"
    sha256 arm64_tahoe:       "fa68f18066ea0309400af8bd6e23a91fd0c5540c1ae16869e3756ad28eb94931"
    sha256 arm64_sequoia:     "9364972fd66247bde591aa1d3207d07091d484a0aa30c9e887cbe074f18c783e"
    sha256 arm64_linux:       "354b196ee42406b4b87a7eccf94e4248f54819c473daffac3f05a99cb1668290"
    sha256 x86_64_linux:      "138432c430142b405833f102a1cff8d4dec83865e3064292e1a92d5c58114a5f"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{formula_opt_prefix(openssl)}
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
