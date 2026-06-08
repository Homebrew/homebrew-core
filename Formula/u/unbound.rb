class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.25.1.tar.gz"
  sha256 "0fe8b6277b0959cfd17562debac0aa5f71e0b02dc4ffa9c60271c583edab586f"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/NLnetLabs/unbound.git", branch: "master"

  # We check the GitHub repo tags instead of
  # https://nlnetlabs.nl/downloads/unbound/ since the first-party site has a
  # tendency to lead to an `execution expired` error.
  livecheck do
    url :head
    regex(/^(?:release-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e70af9383d71c712ef5b32dcd38d2a49650e27e4f0159d4f0b48feb8270b12a2"
    sha256 arm64_sequoia: "240384c7f32948f485565940a73a5e4a724c8c6a381f40c56a6f0cbdc31a8645"
    sha256 arm64_sonoma:  "a72e00a0af995e8c5cf003f241fa70e616dfbd3613439e9c37d409fc847d0d95"
    sha256 sonoma:        "9b23b437d3d41d269b8c49488209126aa615e67eaffc672f698a4600fdd64eb9"
    sha256 arm64_linux:   "545b8ae4cd36a4f51ed41235c834e4facbb7b4528fa8bd3d780531e50da53584"
    sha256 x86_64_linux:  "bc33286a98306d040db92f0c2187b098119ce3ced6f70c5a19c4e718f2b0cbd1"
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
