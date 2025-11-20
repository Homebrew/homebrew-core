class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.24.1.tar.gz"
  sha256 "7f2b1633e239409619ae0527f67878b0f33ae0ec0ee5a3a51c042c359ba1eeab"
  license "BSD-3-Clause"
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a4fead66dfb4bc13b6cb4bc86d8d1ccc575a4be81f302d8c6a727f0eda79a296"
    sha256 arm64_sequoia: "14cd3f7445095878f8cad653a17930a72f693212558d1275dc435466f116a781"
    sha256 arm64_sonoma:  "ace4f490254fc339d4c4bd5df16a849e0dc8ac5f5b0378e18c29eb97ef4f867f"
    sha256 sonoma:        "824d9ac0ed639af4e1bdd70f1dbf69cacbf5eaab1f88d6da3dd6170807d2b876"
    sha256 arm64_linux:   "06d817c11cb6c3c88fee2a9b2a647f566d8ec711dc87fe139c34dd7c16727707"
    sha256 x86_64_linux:  "86a8bd5b188b8b0c8687f97491a25e52eb45d45d5e91ca979b2ce586b0c0f9e1"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    expat_prefix = OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr" : Formula["expat"].opt_prefix
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libexpat=#{expat_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args

    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make"
    system "make", "install"
  end

  def post_install
    conf = etc/"unbound/unbound.conf"
    return unless conf.exist?
    return unless conf.read.include?('username: "@@HOMEBREW-UNBOUND-USER@@"')

    inreplace conf, 'username: "@@HOMEBREW-UNBOUND-USER@@"',
                    "username: \"#{ENV["USER"]}\""
  end

  service do
    run [opt_sbin/"unbound", "-d", "-c", etc/"unbound/unbound.conf"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
