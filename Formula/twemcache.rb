class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.2.tar.gz"
  sha256 "49905ceb89bf5d0fde25fa4b8843b2fe553915c0dc75c813de827bd9c0c85e26"
  revision 1

  head "https://github.com/twitter/twemcache.git"

  bottle do
    cellar :any
    sha256 "24aa937f8757cab1bad5e0d774478c18f7baf6e2ddc2fee78a2d48a8bf66f381" => :sierra
    sha256 "08efcbeaabad2800d757213a7919b83772f09bbb852e17d8be5d8b70e332309d" => :el_capitan
    sha256 "afe9fcd8a6e8c4c8aac98b2484da12b44126a6070e810fcba3441bf1afa899cf" => :yosemite
  end

  option "with-debug", "Debug mode with assertion panics enabled"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      ENV.O0
      ENV.append "CFLAGS", "-ggdb3"
      args << "--enable-debug=full"
    end

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"twemcache", "--help"
  end
end
