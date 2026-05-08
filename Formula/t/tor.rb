class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.9.8.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.9.8.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.8.tar.gz"
  sha256 "ac1f394e2dd2ab0877d27d928fd0d9e86662fe3ca6afdffb9fd9b6f0f96d05de"
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
    sha256 arm64_tahoe:   "3284d7b6a88627858eb8e326b22dcd072eaf8bc0b90ba299915d4976ad50972d"
    sha256 arm64_sequoia: "35d19c15fa2d5b763e3887559fad09342498def577d1829dd9889061e9822660"
    sha256 arm64_sonoma:  "3ab57e2582dcbe80518a9fe1ef8198a130f1ee0729aa270341a9de50bcac7ac2"
    sha256 sonoma:        "c65a2461b506f46f5688b6e389b1c5db575ec39888e6d3a82d65f9d535ddd095"
    sha256 arm64_linux:   "e153caf72c221f68acc7e0493d28c1d70aa6efbc217c3c91ee632222514ef803"
    sha256 x86_64_linux:  "7da3be67c396e95a7a2ef56206c7e54855feea40e1cb876b107382b1ee12c3f9"
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
