class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.16.3.tar.gz"
  sha256 "ea0c6665e2c3325b769eac1dfccd60fe1828d5fcf662650039eccb3f67edb28e"
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
    sha256 arm64_monterey: "6d05e0efe0d22c70194b49353cc5495eba08ede20f5c0d5890f67dd7ad5821d0"
    sha256 arm64_big_sur:  "efec4272f2478a637b9f2cdb11df4d31a8dbf192cef025e7dbae16a9a3e703fb"
    sha256 monterey:       "2da8be7cf1eb7439043c940e1cc38e40e681cd7f2ba22a14a53a077ba05e27e8"
    sha256 big_sur:        "f78107399b34e043c93f14c827831d36de176beee28797cfe7dd8ba0944e1842"
    sha256 catalina:       "2b5067890d99af7e09ec08a82145df9d35fa4cbd36f2ec4997b00c6932cb708b"
    sha256 x86_64_linux:   "291a9a65af515036927268326e852f268507552cd73d62abe05dac1098b41812"
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
