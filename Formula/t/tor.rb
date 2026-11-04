class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.16.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.16.tar.gz"
  sha256 "6180e193152f4525bdca5475168419b2a2035b963c3c60162a187f86e6160e48"
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
    sha256 arm64_golden_gate: "85982c1568c3f7a71e0fdbbdf2264f06113cb6248d16dd8c576c6fc45bd0dd00"
    sha256 arm64_tahoe:       "8a0e06a45e1cb2e66134214affce18fa10217581d1b5de1355fbafe17ed50798"
    sha256 arm64_sequoia:     "e5390510b15843786f7ee8321cc44d5fb98dcacfcd77cbed133b0eb056819066"
    sha256 arm64_linux:       "429ce6ecb4f5ca7547969d3f1e4e2f3861108b2da25a1233ef564fd9ea262c7d"
    sha256 x86_64_linux:      "abe0bdf406eeaeddd184ab52695a1ab43f67c28ae5bfa96d679e255486d310a5"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{formula_opt_prefix(openssl)}
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
