class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.7.8.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.7.8.tar.gz"
  sha256 "9e9a5c67ad2acdd5f0f8be14ed591fed076b1708abf8344066990a0fa66fe195"
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
    sha256 arm64_monterey: "c21ec67486736803cb3be6e38fb863be5bf000d5928835bee7eeebed2b41243f"
    sha256 arm64_big_sur:  "164b25974fe419e4fcacbc7b7acb8671a85bc714b7ed823ad9a963e83a0906bc"
    sha256 monterey:       "9fcc7c01fd7e57d1c9ee2b137be654d4e6b2c68b3f9a7946658f437cd72c7e1c"
    sha256 big_sur:        "8f68a8c3b3a78ecaf6d7644929ad5344b0974fec9cfd86981d625a3b9b9bd7d7"
    sha256 catalina:       "744db5e9e12851cdfa3c242d1754f9bc39336c18025b67e580adff4537c1d646"
    sha256 x86_64_linux:   "cff2b0c802495b723d4f8fb1cc2225bf9ab1cff5baf3be23c2f34d9df8ef81dd"
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
