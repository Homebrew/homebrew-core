class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.24.2.tar.gz"
  sha256 "44e7b53e008a6dcaec03032769a212b46ab5c23c105284aa05a4f3af78e59cdb"
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
    sha256 arm64_tahoe:   "6c59b63075d8b30aa313d5b24a81e3654201c757b62a59605a7985372e88c210"
    sha256 arm64_sequoia: "df3c8215fc595feb7c384a959b9e5dfbf38b123749626544c7f096db347ff9f4"
    sha256 arm64_sonoma:  "223d64d8ff9545d24257ef8231d9301b5116b8f33e4aeec15d60474b4a884096"
    sha256 sonoma:        "211b54d6d74bc64552ddddad1e2a1d5799026177d1b17abc7cff8da77db56f3a"
    sha256 arm64_linux:   "b603481910ad8c62e18000618401de4511228fb837c86b7dc59382dce974996a"
    sha256 x86_64_linux:  "4dca3d86d32cd14d33167b2d0cc21df1a306b0050581cb614a1f88249781a237"
  end

  depends_on "libevent"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    expat_prefix = OS.mac? ? "#{MacOS.sdk_for_formula(self).path}/usr" : Formula["expat"].opt_prefix
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-event-api
      --enable-tfo-client
      --enable-tfo-server
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-libexpat=#{expat_prefix}
      --with-libnghttp2=#{Formula["libnghttp2"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
    ]

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
