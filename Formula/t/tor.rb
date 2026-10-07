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
    sha256 arm64_golden_gate: "c38cee07720d93e1c32430a2e7021596fb18b33500144371cc77c2faafde29e1"
    sha256 arm64_tahoe:       "903cb957d85afbd096f32ceaabafb5b91f368c006e187a9394f889e1c54c68d3"
    sha256 arm64_sequoia:     "1b6c48c821442eb4bd877c168cac79cafd1139ee30d1587e8d0a173139731e9b"
    sha256 arm64_linux:       "c9051dbc2b0ebd45e4972d5e32b47911c4d9b028b0a95e306becf0ed1b559c94"
    sha256 x86_64_linux:      "b4d720288cbf253eb5dca558f1edff3f31a1d9d4e9868a6b4e73d0f99f28d437"
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
