class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.6.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.6.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.6.tar.gz"
  sha256 "a89aba97052e9963a654b40df2d46be07e8a6b6e24e5437917fd81acd90a7017"
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
    sha256 arm64_tahoe:   "0ef89fbe46ae01eb13535f136f86905a7c1cf6d709a16bf42a2b4a0ee0321935"
    sha256 arm64_sequoia: "152bc133e9a02aa116a0648c25372f067f0a7dda8ea8121713811567176fe854"
    sha256 arm64_sonoma:  "804870529d75fe0e9960094756d88a4448c44e3f234365d0960a78466a748e79"
    sha256 sonoma:        "c03763050f73ea726be00e05c06bbad6cfacf21a7a4362c101589dbfb9faf820"
    sha256 arm64_linux:   "e27de03c84dfe6a69ae6641ad5beed0282152e8849b34faa36403c0946edad09"
    sha256 x86_64_linux:  "64e22323a9d0b8f9581c8f56071b58faab8c615379eee21b7977da8678964b8b"
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
