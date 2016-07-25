class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  url "https://github.com/simoncozens/sile/releases/download/v0.9.3/sile-0.9.3.tar.bz2"
  sha256 "30dfce5dca517280f3c41c34d52e7983080f880f22aca6ddca471d541a2d3f49"

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
  depends_on "freetype"
  depends_on "lua"

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
