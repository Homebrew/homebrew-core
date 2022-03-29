class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.6.10.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.6.10.tar.gz"
  sha256 "94ccd60e04e558f33be73032bc84ea241660f92f58cfb88789bda6893739e31c"
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
    sha256 arm64_monterey: "7f4aad9e8773c7b15b5a82d7aaa91c8c663dbc21295dd7d5fa5fc80354d21e5c"
    sha256 arm64_big_sur:  "3c2c8f498768c8dbcd1a526892fbcd366c94a06b1b2325f6b0a1d939e6331d64"
    sha256 monterey:       "c2688018390c6e0f920e7c81f8bc6430230e0ca2908db8b8ab6895bfaf55e3e6"
    sha256 big_sur:        "89b313e2ce58e88176b305833701e0b839656bdf9d75faeed27467941b9b55e1"
    sha256 catalina:       "bca86f39efc3e73b3ff92e56eab4b728e2f1d170efa39692286a4f4c5854163d"
    sha256 x86_64_linux:   "c27c53dcfd9eab911c370515a2d1159cf40c531eb6cbf1c08962d170dbca2f4f"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
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
    if OS.mac?
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    else
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
