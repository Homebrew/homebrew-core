class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  url "https://github.com/simoncozens/sile/releases/download/v0.9.4/sile-0.9.4.tar.bz2"
  sha256 "1c696679e5243d0448705db86227eec57a000846f02a964f882b7978c46954d5"
  revision 3

  head do
    url "https://github.com/simoncozens/sile.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle :disable, "LuaRocks requirements preclude bottling"

  depends_on "pkg-config" => :build
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "lua"
  depends_on "icu4c"

  depends_on "lpeg" => :lua
  depends_on "luaexpat" => :lua
  depends_on "luafilesystem" => :lua

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "SILE #{version}", shell_output("#{bin}/sile --version")
  end
end
