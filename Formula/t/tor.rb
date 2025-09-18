class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.18.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.18.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.18.tar.gz"
  sha256 "4aea6c109d4eff4ea2bafb905a7e6b0a965d14fe856214b02fcd9046b4d93af8"
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
    sha256 arm64_tahoe:   "032509a846d1f1f3a8c12dd1cbffd3aa31cf1d0a052babf0e8aca3ea4273a78a"
    sha256 arm64_sequoia: "d7bfde19f263dad095fcc739c51fc4d12c1b743b406944afd8883658838b90ad"
    sha256 arm64_sonoma:  "2a6276f2e28ed77ee16b42b04b501c9186e274697bb1e77faecdd4ed2da2bf6d"
    sha256 sonoma:        "1536160c54980066011c2e9300793b7500f331a1b70848c45c0cd4d62b625970"
    sha256 arm64_linux:   "c11d7b94152b9f588a238df5b6765171d80d1ed0e315b49e66bc60bef6e59b2f"
    sha256 x86_64_linux:  "4207df84407e6152da41a3982801740bd51aa819db4858a26029ff6daa68874e"
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
