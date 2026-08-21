class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.4.9.11.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.9.11.tar.gz"
  sha256 "2e6c1720118c812acf0079fd47cf91b6bfaba5d766c321c4d3d2a28d6a11a8ed"
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
    rebuild 1
    sha256 arm64_tahoe:   "f40abed00c0583d77db71d59306931c62b237afbc09cfe2a9a70569631d636a3"
    sha256 arm64_sequoia: "dcc6c8a124af75fa28ca2d4e24ee3f4df60f9a9a6c51e6653c74acb55f7c31d7"
    sha256 arm64_sonoma:  "30f1a580580d7b80b8c143fe0829d5e0db021980a9d95979f01d3b7870403a55"
    sha256 sonoma:        "84fea8e84da6f4a967d920ed9fe7b23926004d278b36dd3b6da20376bd8fe46e"
    sha256 arm64_linux:   "e2f147b43fa4bbaaa9758e8e4d16435727eb9ca5e43d60c7405781a240116faf"
    sha256 x86_64_linux:  "378c975a7d21d93718dad2e1e1eb6f3d9b2f0789a248188e01fd3573959e232d"
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
      --with-openssl-dir=#{formula_opt_prefix("openssl@3")}
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
