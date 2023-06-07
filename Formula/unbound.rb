class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.17.1.tar.gz"
  sha256 "ee4085cecce12584e600f3d814a28fa822dfaacec1f94c84bfd67f8a5571a5f4"
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
    sha256 arm64_ventura:  "caedc25a2a2bf62d012984269575ca48adf7cfbabcb3aeb993e337c42bf0b373"
    sha256 arm64_monterey: "c870e90be341227604999ffa9b66bac97bb193a9088fe09ad2ad5a0471dbbd6b"
    sha256 arm64_big_sur:  "fee17cf7d52a3cd3d7a1767eee35984bbf5b70bb4c0d649240be8c7acc1967c1"
    sha256 ventura:        "8c8633701f58288a23e8b78734584b69354ba48af404ee0cac7cd6dfb97e29d9"
    sha256 monterey:       "9f0b67ee5dd9d83cba390ad705a6f3b434ea364b2b4930e04f0215827c1883a9"
    sha256 big_sur:        "55e865da9441e948209a775239c4217bd7d67aa6be6f18d1e794d078af7be1c7"
    sha256 x86_64_linux:   "bf896de5292674b98a0056d6efc383c8b3b40f2114386a1ec74f4e81166c2c62"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  uses_from_macos "expat"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--with-libexpat=#{MacOS.sdk_path}/usr" if OS.mac? && MacOS.sdk_path_if_needed
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?
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
