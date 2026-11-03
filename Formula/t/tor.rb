class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.15.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.15.tar.gz"
  sha256 "1911f5b216a6814ed143a08bbcff1c6dc96d2ca3b505df9a21876080a92963f3"
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
    sha256 arm64_golden_gate: "a0ce7e7a4d30ed67fba3805be4838a3fc9ac7d3ca4150aa1ce6221b757b9be4e"
    sha256 arm64_tahoe:       "592f4dd86706fc050f2e26708efc6fefa67e004b48771851dddca47f82603673"
    sha256 arm64_sequoia:     "2faa868f5e0613f61b6d8f197164cca2a0a6e7be63e7a430b8274a3f4b88747a"
    sha256 arm64_linux:       "9feea987259778da9c802b18f351ef5590c41936b95be33c7ea95252a91245d4"
    sha256 x86_64_linux:      "a82cf1db5be775e8c233bd648352c984509df9367c6264b3a7e93ca9e7ddb78e"
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
