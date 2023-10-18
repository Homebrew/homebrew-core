class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "https://tinyfugue.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "9658a3933eea4da8acba5ea118e6410cead8d4caaecb056b18a30766839fe722"
    sha256 arm64_ventura:  "cdc8362ec9ee41a8c97c4c6360065a880011b97baf5e383e4d613267f96e57f1"
    sha256 arm64_monterey: "b426a9fd58d23982e8659a204f9daa3e18c1853ac8fc7dbcc21817e16dfcbfb5"
    sha256 arm64_big_sur:  "af3018b2720b6a40af09543d2353b19b9a1124795a5d1f51af893de62d136ae5"
    sha256 sonoma:         "dc4c1a3c25a89c2bf9a22e06fffc239aa8e1b30e4ff68f69458376e164e03b7b"
    sha256 ventura:        "e96231ee3e1f846935d2b0f05b850b89124f650d7a3365d89caa1611da0b8b51"
    sha256 monterey:       "456970a772014d46c0d0ca76b0231c66a4ce8550c305a38aa2127c7f9ec6bce9"
    sha256 big_sur:        "1776efc11b784517a363b5a40091a6c36e177905d90271c20264c7aa0e05b933"
    sha256 x86_64_linux:   "aa2b100ca650f52a73104c238ae09e6cfffc59a7a94436733d128ce82f0b5844"
  end

  disable! date: "2023-10-17", because: :unmaintained

  depends_on "libnet"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "ncurses"

  conflicts_with "tee-clc", because: "both install a `tf` binary"

  # pcre deprecated pcre_info. Switch to HB pcre-8.31 and pcre_fullinfo.
  # Not reported upstream; project is in stasis since 2007.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9dc80757ba32bf5d818d70fc26bb24b6f/tiny-fugue/5.0b8.patch"
    sha256 "22f660dc0c0d0691ccaaacadf2f3c47afefbdc95639e46c6b4b77a0545b6a17c"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `world_decl'
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-getaddrinfo",
                          "--enable-termcap=ncurses"
    system "make", "install"
  end
end
