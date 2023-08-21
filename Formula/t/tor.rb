class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.14.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.14.tar.gz"
  sha256 "a5ac67f6466380fc05e8043d01c581e4e8a2b22fe09430013473e71065e65df8"
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
    sha256 arm64_ventura:  "eecb3e82d97ae71ffaae574dc68dd81af96cf3e099c1df22c9edc7c9a29f7152"
    sha256 arm64_monterey: "3e49f41b47a1ee0e49f1cd0df77d41024e296c836cf0fbb87a3b839ffbda5744"
    sha256 arm64_big_sur:  "9e843727fc006d8d551e6ee39f2595843e33d44334dcd66838ff26c1c26c164c"
    sha256 ventura:        "4127674d3e5c1330dfe5ea7a0bece305a02a5f17ea5c9485888b46c4a9c3b8bf"
    sha256 monterey:       "f04a656da073f65e17642a134610b2e68eb25fe4a4c24f94532d1162f3917b2b"
    sha256 big_sur:        "07a92f3a4186943d70093b0eb46b8f7e8bee40cef5d7116f933c35af8052677e"
    sha256 x86_64_linux:   "90d989022f9a6d73c85dd67f6dd891a4b1f7db7d74ff8372a6e89a61cbe67e84"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
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
