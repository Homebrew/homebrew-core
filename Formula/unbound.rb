class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.16.2.tar.gz"
  sha256 "2e32f283820c24c51ca1dd8afecfdb747c7385a137abe865c99db4b257403581"
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
    sha256 arm64_monterey: "3622c6fcc10b30da1c8551d5b78179586de78801357bef214ea3d1409d3b4414"
    sha256 arm64_big_sur:  "33a1c83064194f1d3e35500a85ac16ebb20b874837c1fa3a2ff520fbb60bd953"
    sha256 monterey:       "578898bbe7e5fa88ab0af53f87779e5a452ab77e2c6fae51cf87e33a01366eb8"
    sha256 big_sur:        "a4e6d426792e5074eb217df923a87e0a01f6ec16f9b4da500a0bd9d1dc45c562"
    sha256 catalina:       "a3ea74572296dd76055c2dc3939ea450712b76e81476d2ca30e1a09ac399274c"
    sha256 x86_64_linux:   "cec4fbcab6b17b9ee23f330a31d113abef88d40d4ade321cf52d1ef8256d6f2a"
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
