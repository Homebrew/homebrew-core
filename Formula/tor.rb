class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.6.6.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.6.6.tar.gz"
  sha256 "3423189ba455372021ed44e0be576d181f2908cbd9bdef202d9c11c950882e12"
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
    rebuild 1
    sha256 arm64_big_sur: "9969523c39fb2eaee7698ffad791ecc5d489fb32cfe67de6f31bc35331a334c4"
    sha256 big_sur:       "08c739697ab5664b1d175392ffe8352c0831edf572437d570867d031a1e6eaaf"
    sha256 catalina:      "b06d239b25ff7b23ec4da8dbf50f68abf61cc2111f9909586fc369d7cb427f68"
    sha256 mojave:        "53d0aea00f1bfab9b71a8df97c665b572e05102747e35bb29be72b7f95f028c2"
    sha256 x86_64_linux:  "19f2b3ccc56a71b1cb275b6d02b6a8e7da65abbde660783abf6cb582922d382c"
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
    on_macos do
      pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    end
    on_linux do
      pipe_output("script -q /dev/null -e -c \"#{bin}/tor-gencert --create-identity-key\"", "passwd\npasswd\n")
    end
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end
