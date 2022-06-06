class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.16.0.tar.gz"
  sha256 "6701534c938eb019626601191edc6d012fc534c09d2418d5b92827db0cbe48a5"
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
    sha256 arm64_monterey: "660dd6ae5d768584e291964809d68c21d3e8695404f2c3c91913745bb7df098b"
    sha256 arm64_big_sur:  "a30f6dac7431d502537274616be2a087ba8c52f9c4b8205885bb79739df32c0b"
    sha256 monterey:       "5c8c1c54068fec0a3941d50730a0711151f1b19fac62551a0848848986e6e564"
    sha256 big_sur:        "8364da64161e2f738372a047fd2db78d8765e3892907cf5eabe087908f748461"
    sha256 catalina:       "745930af1a13dabdb8df038821fad347b17835ddc02f29cd6cacb119b406f489"
    sha256 x86_64_linux:   "3a8f6d3d8b9a934525d449e406d29c256d37b1e82292eed7aceff9be50d13399"
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

  plist_options startup: true
  service do
    run [opt_sbin/"unbound", "-d", "-c", etc/"unbound/unbound.conf"]
    keep_alive true
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
