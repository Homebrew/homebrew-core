class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.9.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.9.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.9.tar.gz"
  sha256 "bd75ba7fd68f607c7806fcf70156a300aa926e9ad69a5e56a8e6414f5227e833"
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
    sha256 arm64_tahoe:   "19a0c6dd01e54b9a94d93a968c596c7eed96201216f8e348c20e99f541ad8621"
    sha256 arm64_sequoia: "2107066fa6baaa6fd1b0fd726d84b5401267ce7d2c412b838def7be86605416a"
    sha256 arm64_sonoma:  "7f56f5034476b0df55c46b190b05f4d86805a43d583b0c975d90be599dd32ec7"
    sha256 sonoma:        "be07c8cee4052e4c967dd866a00b1347fcfc86bebe5091f876689fbe71135ba6"
    sha256 arm64_linux:   "0737bfe823b70a4619e902f8cb3d983d9610f63e0471d258667f3d7aef387f91"
    sha256 x86_64_linux:  "e1b8756982d94e5a77dcc36ed27a28db3ed73af1ba28acf2290fe5d46b44ea1c"
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
