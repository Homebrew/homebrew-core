class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  # This should return to using a release tarball when >0.9.4 is released.
  url "https://github.com/simoncozens/sile.git",
      :revision => "befcd813e1dd46f7af6d11ffd0b0ee525e8db1fc"
  version "0.9.5-alpha"
  revision 2
  head "https://github.com/simoncozens/sile.git"

  bottle do
    cellar :any
    sha256 "4c6bba421ff793adc2b04d4e7b0d9aa3688e91808f04dec09925dae37b924641" => :high_sierra
    sha256 "7b9172ea75ec49258008d95283f845c1189314a3ad453fe788c93b6bab3137a6" => :sierra
    sha256 "fa20352cf71e8c0a359f33982a4c062e18ae99c22e4dcb1c389a5645060ce5ad" => :el_capitan
  end

  # These three should return to being head-only when >0.9.4 is released.
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  depends_on "pkg-config" => :build
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "lua"
  depends_on "icu4c"

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.1.tar.gz"
    sha256 "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b"
  end

  resource "lua-zlib" do
    url "https://github.com/brimworks/lua-zlib/archive/v1.2.tar.gz"
    sha256 "26b813ad39c94fc930b168c3418e2e746af3b2e80b92f94f306f6f954cc31e7d"
  end

  resource "luaexpat" do
    url "https://matthewwild.co.uk/projects/luaexpat/luaexpat-1.3.0.tar.gz"
    sha256 "d060397960d87b2c89cf490f330508b7def1a0677bdc120531c571609fc57dc3"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua;;#{luapath}/share/lua/5.3/lxp/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        if r.name == "lua-zlib"
          # https://github.com/brimworks/lua-zlib/commit/08d6251700965
          mv "lua-zlib-1.1-0.rockspec", "lua-zlib-1.2-0.rockspec"
          system "luarocks", "make", "#{r.name}-#{r.version}-0.rockspec", "--tree=#{luapath}"
        else
          system "luarocks", "build", r.name, "--tree=#{luapath}"
        end
      end
    end

    system "./bootstrap.sh" # Should be head-only when >0.9.4 is released.
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (libexec/"bin").install bin/"sile"
    (bin/"sile").write <<~EOS
      #!/bin/bash
      export LUA_PATH="#{ENV["LUA_PATH"]}"
      export LUA_CPATH="#{ENV["LUA_CPATH"]}"
      "#{libexec}/bin/sile" "$@"
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
