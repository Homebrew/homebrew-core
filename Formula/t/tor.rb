class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.12.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.12.tar.gz"
  sha256 "c0d307c9dcdaee4848a8ca53e9d6c4ec92823e4f30be12790b0fbddfc6515f5b"
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
    sha256 arm64_golden_gate: "cf21887b1378191fc30ad4c445ed14f4f4662febf7f1a67159b74f81279c27d6"
    sha256 arm64_tahoe:       "18a352c3e1f51b6c1d47bcecf81331350a37c8721ab00a57461c3e39043807af"
    sha256 arm64_sequoia:     "0bbcecc4ef3f9f9671ff3254c1b16e1537d734d9aef1b774b3e3d9f4404b1220"
    sha256 arm64_sonoma:      "11ea9b7123bf721de6c8b193554c8f72f9f7f2860045bf994882fdbda64593a8"
    sha256 arm64_linux:       "8847c863781831e48482ab561ff86a90620467f88868b7a4eddbc8808f7904a9"
    sha256 x86_64_linux:      "82724e9a4570d809e622d90b9d2d619554a662d9d9ca12d2f5a9a706db84bab7"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{formula_opt_prefix("openssl@3")}
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
