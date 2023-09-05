class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.5.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.5.tar.gz"
  sha256 "6957cfd14a29eee7555c52f8387a46f2ce2f5fe7dadf93547f1bc74b1657e119"
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
    sha256 arm64_ventura:  "c17be70561804a03e94941f88b7490bb2ade499aafdd8c76b67dcc8185d206a2"
    sha256 arm64_monterey: "5a2d29cfd325b74c207678d6aa0f06492a914944db733e7ffbe03dc25ede0f0a"
    sha256 arm64_big_sur:  "ba723e035c8e5c3684cd9598a42fe8a9dea42a991d6105e81e3789512ff5354c"
    sha256 ventura:        "bc0d15cc0eb2f587203a53b937fdbb05371537555d9f1361322de948b0506707"
    sha256 monterey:       "17986aa8b3609a7777e629a9e65db61c65ec9ac01e59e197f0ec3ffd8d123fb8"
    sha256 big_sur:        "1c011fe400025f3c9c5b569f8d7e180c87fe7bf906ac12040a040c05fa291139"
    sha256 x86_64_linux:   "86075a5ff1afc27cc28982f9ed917374526b7576bce162e48a3b6a4a00385131"
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
