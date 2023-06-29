class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.17.1.tar.gz"
  sha256 "ee4085cecce12584e600f3d814a28fa822dfaacec1f94c84bfd67f8a5571a5f4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "987c9200c5657ef18b7e81ba89981be152fd10bad97d4475870af1837b7eac9f"
    sha256 arm64_monterey: "3d73fae5e1fbda041be0837c2b6e7e943fd15bb49ce66abde3e3b10472b77cb3"
    sha256 arm64_big_sur:  "f256714d356be7fb1943560a43cd56136b28bea815b34b1b7440933f0d68f0ca"
    sha256 ventura:        "519d202d9febdc31f4a1828f0702502f49ac130fbc613aa67e6a5ae974011438"
    sha256 monterey:       "33ca879d0730f0334b20813e68e79d35db8d58e35b06ec275f04d02d49b0f722"
    sha256 big_sur:        "2164a225e8230588b15bf58add99ce28ffeae2393d861b5af29263be64bdc4c0"
    sha256 x86_64_linux:   "d1c97adb75bb839c008a26eab4cf421c461dcb130524106a1569a5a2b6159b11"
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
