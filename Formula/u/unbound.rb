class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.18.0.tar.gz"
  sha256 "3da95490a85cff6420f26fae0b84a49f5112df1bf1b7fc34f8724f02082cb712"
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
    sha256 arm64_ventura:  "e2cc743d4211eff9d6837a79df3fd884d754dd020c1aecd9cb2fab7adc4e5145"
    sha256 arm64_monterey: "673b1b3eea47d69001c9909cf112e4b2d8012e4b1c968b1ee1775677e3f3b96c"
    sha256 arm64_big_sur:  "b803acb93cc1b24e523ffe59c4f49607b24926c44c41194fcf95df0b6b01bcfd"
    sha256 ventura:        "e326c25d35dc1efe2067a42ac505f7be1ecd8cf6458a42782c7b044173e3a240"
    sha256 monterey:       "e57b4ac52c5a7a4b19b8fd50ed786b46c25ddeffd2dd0c36e315996324531caf"
    sha256 big_sur:        "982192b56b9ac8eca1c969eaa726acb1474867dc9d021c96006c3632fcd308b5"
    sha256 x86_64_linux:   "d0eebb54a15a12b2a9d765a1fe6bb17503c2d0ec5cdc7a681fffecf9e321906d"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

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
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
