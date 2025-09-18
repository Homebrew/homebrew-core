class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.23.1.tar.gz"
  sha256 "6a6b117c799d8de3868643397e0fd71591f6d42f4473f598bdb22609ff362590"
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
    sha256 arm64_tahoe:   "ef3b28285c148fb0d3b0dfad49ad8a12e2375b56b1c2a9bfe7b202a1c41181fc"
    sha256 arm64_sequoia: "e11348122c286c37c6264313f202dc3775c26ed15f657dc22846dcb77c4b3f7f"
    sha256 arm64_sonoma:  "bd75449e6ea8b74653954fcd2f8a56c5473c3f0d4793c7d758fc1b705a5622fa"
    sha256 arm64_ventura: "c4533e3811f75e5f81d563abcb0354679905003fd18e8cbbafe44e952ba87d7a"
    sha256 sonoma:        "fcba0d8c0ebf33f4c9e633f99bd28f79aafbdd18318be6c0c07a7d2bfa530d7d"
    sha256 ventura:       "5fb743b83770ed13c84994d59d511a237057db7c3c99db3d0761ffb289626bc1"
    sha256 arm64_linux:   "34238dcc2913834b6191f524d69326b35609a670617d264b43836bdb9ce107db"
    sha256 x86_64_linux:  "af5f23331f736ad40f1bdde764f39cfa7bd24ffc5a5c3e5a80eb639e3cbfe40e"
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
