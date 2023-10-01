class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.6.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.6.tar.gz"
  sha256 "552d895fcaf66c7cd2b50f5abe63b7884b30fed254115be7bfb9236807355088"
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
    sha256 arm64_ventura:  "71a2aa174df2b071b657096c7544c0c892632ffe929e1ce54e94d0aef0d5fd10"
    sha256 arm64_monterey: "e19ebb762bdbcda31a64bbd2aad3803efd758cf34a37adecef9e5270341a23ca"
    sha256 arm64_big_sur:  "d7d36b0a66786fe354d44c13ddb3a7f84022acee3d42a6855772ea57d42cda3f"
    sha256 ventura:        "274f8afbdd334afa0f447829d26044259522a2916de09dfbff9b4ad7bd0e3aa7"
    sha256 monterey:       "f5e34ff60af486248bd103b2a30c841a70d132153d6866b5cdb5fdace6d8a820"
    sha256 big_sur:        "652bbe756ab9e36e29abe711d4e4b8e78b1fda2bb4c4d07b30acaeef03a1ce18"
    sha256 x86_64_linux:   "6114e61cb9a23d85aca74949640bee254dde955eb3b0bd03414e37aa527e62a6"
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
