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
    sha256 arm64_monterey: "b54528b3c94e231bb002ffac1fc153ac577ce1dfa4395ed95aaed4ddcb41d54c"
    sha256 arm64_big_sur:  "80c98a229741678cf46f2785ac131838593aea19dad6e3ad597c0d67cd702d2f"
    sha256 monterey:       "c251f7ba2d079439e745634b9c1e5b3ac9f08fc0133dc2c88c440213cb1220a9"
    sha256 big_sur:        "fe60bb13775abf150cf8f3fe52414ffdcea6afccd524e867c191e44b6442f4b1"
    sha256 catalina:       "cef63c482d833863aa54154a09eb28c892c7fe784635cd3a49f5ff6b0ac62b1c"
    sha256 x86_64_linux:   "1aaca8d5da81a8a8ca1a7ba4953693f5a48381e87efcae48c2743d890e59d314"
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
