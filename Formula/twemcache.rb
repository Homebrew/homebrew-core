class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.3.tar.gz"
  sha256 "ab05927f7d930b7935790450172187afedca742ee7963d5db1e62164e7f4c92b"
  head "https://github.com/twitter/twemcache.git"

  bottle do
    cellar :any
    sha256 "f644983ebb4d4125cafe67f11f1cc8e0acd164778e4c99120f054432c23a16cd" => :high_sierra
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
