class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.22.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.22.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.22.tar.gz"
  sha256 "c88620d9278a279e3d227ff60975b84aa41359211f8ecff686019923b9929332"
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
    sha256 arm64_tahoe:   "7f3241e9eefa6165f9f928cd7ee43b86e8c058ee5f013a1fb044f4044038c911"
    sha256 arm64_sequoia: "27302145a68cae56413074da81e12663424f562f0a486973bfc4596d2f7a23a4"
    sha256 arm64_sonoma:  "263fa1e5326729475a82219a58ff902f0f2aac76dfdec53009050cf67f1b7522"
    sha256 sonoma:        "65c1a633fffe9763ee238c6db576154234903e9b4740303293f5e83706213434"
    sha256 arm64_linux:   "b0a22582b7c002f6d28565b024ac2644da59fe360432152aa9a62d3b9eec2515"
    sha256 x86_64_linux:  "eb4660bde436525e35bfd742d853542d6f7bd24fd071d3a547cd2e4bd68d1fce"
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
