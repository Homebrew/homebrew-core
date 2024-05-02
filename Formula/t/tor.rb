class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.11.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.11.tar.gz"
  sha256 "8f2bdf90e63380781235aa7d604e159570f283ecee674670873d8bb7052c8e07"
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
    sha256 arm64_sonoma:   "cb7b16b56ff152236996a7e97977c0f58bdeda87f4aa56d434f05a1a67cb3b77"
    sha256 arm64_ventura:  "66e9dbb092e85fb426c1ea6fcc68359773368f17cc78a196da2fbc6a5a22f2f6"
    sha256 arm64_monterey: "3686f14a95f9e4cd647e561df8eb5e2b0ec11e15471e727b445a68fc6000a2a8"
    sha256 sonoma:         "0966c49400394aadfb9b2beec8d89d664e04e014b830a25a740b8c1ee99c7f75"
    sha256 ventura:        "3eabe17b2273709469bc14f33d418a995226a48eb3203aeebc1ee5e07673a08b"
    sha256 monterey:       "0ecec85a5c493304cf4568d67ea58d985e80ac8f44e6ce5230bd98ef28c85bae"
    sha256 x86_64_linux:   "76f151bd7dc09e17fa696b077ca9ff264eedfd97c706f37c6d918535d6c2737b"
  end

  depends_on "pkg-config" => :build
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
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
  end
end
