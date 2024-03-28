class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.19.3.tar.gz"
  sha256 "3ae322be7dc2f831603e4b0391435533ad5861c2322e34a76006a9fb65eb56b9"
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
    sha256 arm64_sonoma:   "1c74328fd710de4ca59b32cfa8c904efbfb3a957cfc9b73a4add78b30b007a55"
    sha256 arm64_ventura:  "1aeeb206335ddba2eb5ccf68532642f6b373d81b2b112ab42dd5bb9e439542bc"
    sha256 arm64_monterey: "80dc56f3f7642cb3245e26e3a5a2a7e28e04cce6c6843ba58a63bd352f884deb"
    sha256 sonoma:         "c9a62474cf15b79fe6d47fc07fb07dec66940e3a914c8116a996eae14bd9bd9f"
    sha256 ventura:        "1bd4e20b1948c795a5798ba108229887b6f6bdde8349d2bdc140ca29ab5ac418"
    sha256 monterey:       "7a927aec89f5cf471bed32ee99d6fba005af1f5ab3c8870a8dc156ffa1ffcfeb"
    sha256 x86_64_linux:   "c7d900fcfab9b7c6ddc3521560a46a7fb5f13ccbc9a0794292a6acf069fd61e2"
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
