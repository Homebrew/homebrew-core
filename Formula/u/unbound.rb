class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://nlnetlabs.nl/downloads/unbound/unbound-1.20.0.tar.gz"
  sha256 "56b4ceed33639522000fd96775576ddf8782bb3617610715d7f1e777c5ec1dbf"
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
    sha256 arm64_sonoma:   "d747e30c1da19b82c8009e624fda911469d67d107cdcba6ff6686190f5b52928"
    sha256 arm64_ventura:  "7b58a5359abb418b4570ad1a6eee2879ae81ebd75a70f7849d717ccae5d44c61"
    sha256 arm64_monterey: "149a6f0acd98b5161de80d5711381206ee052c08048c76196d39e211b4f63cd9"
    sha256 sonoma:         "23d348d0da7917469fe5a9188a477c094b998d797daee9382c8cc5f2b7ad876b"
    sha256 ventura:        "1656ec5fa19f34d3b9a643e8561de6b08e366c8535d66bc69d4ea19d24445b6d"
    sha256 monterey:       "cfc36b503ebd6d274b42e91d7cdb94183c13dba55aada0f063f4c5395fa72895"
    sha256 x86_64_linux:   "24d82a05b2ed9b197575aff5cc0b5339b727c5b1ca951a1e0c1b09d7931f1058"
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
