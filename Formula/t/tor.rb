class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.14.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.14.tar.gz"
  sha256 "182449ac1c8ff43278da27b69b02040e11d03d0327db6d9126e4190ec6235e4a"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]
  revision 1
  compatibility_version 1

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "5de4b74220d7b580397d72b6073cdede10d309264ea1de6987508dace5ba484a"
    sha256 arm64_tahoe:       "62e8888704102c7de35f1393214a4c3c5e773cd6c183110ac71b76fe3482bda5"
    sha256 arm64_sequoia:     "53631721e4c090f076290c49c4b625b59fdf9db7726031b7926487051a432e90"
    sha256 arm64_linux:       "2e100fac2e2eef88c3ae00284f10ec002061c37c25bfc83bfd0c237f8a2e04e7"
    sha256 x86_64_linux:      "e5132992e18633cd5925438db8b1594d18e5331e0c1bd01eaa76a8fd5a09fc7a"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{formula_opt_prefix("openssl@4")}
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
