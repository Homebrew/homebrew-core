class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.17.0.tar.gz"
  sha256 "dcbc95d7891d9f910c66e4edc9f1f2fde4dea2eec18e3af9f75aed44a02f1341"
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
    sha256 arm64_ventura:  "7f6b083215495c918232e28acc05407a7539e4aacf8243a526b06f244c4864f5"
    sha256 arm64_monterey: "cd06e5b7f62103ad750fab0d5cfdb933c93fc1e40c7769605697b4c8777986b6"
    sha256 arm64_big_sur:  "8dfe71d7aaf0cae625b9c6d1e781e7a83426df3aed669ddee756c49d3442197a"
    sha256 ventura:        "c33cfc378f7f8694e3dcd406683b516edc7c882b4fcde7104c72292dfb2dcb17"
    sha256 monterey:       "6cf8bdba19831e794bbe0e929e773bb0b7eaab510d99db125aebc473c285e0f2"
    sha256 big_sur:        "46bd6470dd62d235900de08625ada5f03d9162a060b6e82badc96e0351843b31"
    sha256 catalina:       "d494000cb01f1b52b69253c9ff09b4a6fe39bb607cf5e60ae3ab648f1432960d"
    sha256 x86_64_linux:   "6359bdf39dc577245648315e93523e2edd476dc8853a580e68e7ad1c7bec5428"
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
