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
    sha256 arm64_monterey: "915c6b513b276b18eb083839926aade01b36f78a8bf89039696e2ed4f31b571b"
    sha256 arm64_big_sur:  "8602cf8aadc2e87948f14ed5f08d489b1759ac35ea832e1679df9f866d371465"
    sha256 monterey:       "f817cb2fc47bb91d48680a309d07f75a777c566b8d52c81f22d4ed857e05856f"
    sha256 big_sur:        "b00a31b7ef110af1c6efe3801cfe44faac0dd785298ba64c38fdbf6b4737259c"
    sha256 catalina:       "3eb38a1d5c4da0d319dab0c20d7e3419506adf45a448ed4921147c0948fc0c58"
    sha256 x86_64_linux:   "9f6128b97ce6f63f9197aa6010a6380afe31a8df9732e1c5d91a3036dc5c8f6d"
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
