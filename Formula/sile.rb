class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://www.sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.10.3/sile-0.10.3.tar.bz2"
  sha256 "d89d5ce7d2bf46fb062e5299ffd8b5d821dc3cb3462a0e7c1109edeee111d856"

  head "https://github.com/sile-typesetter/sile.git", :shallow => false

  bottle do
    sha256 "a5e035b0a1283de83d67e5e2b4b4dcdbd48f7f420f5665905ef18877247ff4c6" => :catalina
    sha256 "3ee7b308149d1c0c3ae51788fbcf9ae5a377d6decc98ea623abbb83a62ffe1a1" => :mojave
    sha256 "74acc6fe4b9c3b7ce17747a89450512283e94bced79241fa4e42f6fbbe8835ff" => :high_sierra
  end

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "zlib"

  resource "cassowary" do
    url "https://github.com/sile-typesetter/cassowary.lua/archive/v2.2.tar.gz"
    sha256 "e2f7774b6883581491b8f2c9d1655b2136bc24d837a9e43f515590a766ec4afd"
  end

  resource "cosmo" do
    url "https://github.com/mascarenhas/cosmo/archive/v16.06.04.tar.gz"
    sha256 "86d17aea5080a90671d965cffeb9b104c19e0e1ea55c08687c0924c4512b52b1"
  end

  resource "linenoise" do
    url "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz"
    sha256 "cc1cdb4047edd056a10dcdeec853dbaf5088e2202941d579e4592584d733f09c"
  end

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.1.tar.gz"
    mirror "https://mirror.sobukus.de/files/grimoire/lua-forge/lpeg-1.0.1.tar.gz"
    sha256 "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b"
  end

  resource "lua_cliargs" do
    url "https://github.com/amireh/lua_cliargs/archive/v3.0-2.tar.gz"
    sha256 "971d6f1440a55bdf9db581d4b2bcbf472a301d76f696a0d0ed9423957c7d176e"
  end

  resource "lua-zlib" do
    url "https://github.com/brimworks/lua-zlib/archive/v1.2.tar.gz"
    sha256 "26b813ad39c94fc930b168c3418e2e746af3b2e80b92f94f306f6f954cc31e7d"
  end

  resource "luaexpat" do
    url "https://matthewwild.co.uk/projects/luaexpat/luaexpat-1.3.0.tar.gz"
    sha256 "d060397960d87b2c89cf490f330508b7def1a0677bdc120531c571609fc57dc3"
  end

  resource "luaepnf" do
    url "https://github.com/siffiejoe/lua-luaepnf/archive/v0.3.tar.gz"
    sha256 "57c0ad1917e45c5677bfed0f6122da2baff98117aba05a5e987a0238600f85f9"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  resource "luarepl" do
    url "https://github.com/hoelzro/lua-repl/archive/0.9.tar.gz"
    sha256 "3c88a3b102a4a4897c46fadb2cd12ee6760438e41e39ffc6cf353582d651b313"
  end

  resource "luasocket" do
    url "https://github.com/diegonehab/luasocket/archive/v3.0-rc1.tar.gz"
    sha256 "8b67d9b5b545e1b694753dab7bd6cdbc24c290f2b21ba1e14c77b32817ea1249"
  end

  resource "luasec" do
    url "https://github.com/brunoos/luasec/archive/luasec-0.7.tar.gz"
    sha256 "2176e95b1d2a72a3235ede5d2aa9838050feee55dade8fdbde4be7fdc66f3a31"
  end

  resource "penlight" do
    url "https://github.com/Tieske/Penlight/archive/1.7.0.tar.gz"
    sha256 "5b793fc93fa7227190e191e5b24a8f0ce9dd5958ccebe7a53842a58b5d46057f"
  end

  resource "vstruct" do
    url "https://github.com/ToxicFrog/vstruct/archive/v2.0.1.tar.gz"
    sha256 "4529ab32691b5f6e3c798ddfac36013d24d7581715dc7a50a77f17bb2d575c13"
  end

  resource "stdlib" do
    url "https://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.tar.gz"
    sha256 "42ca25ddcde59f608694a3335d24919a4df4cf6f14ea46c75249561a16c84711"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] =
      "#{luapath}/share/lua/5.3/?.lua;#{luapath}/share/lua/5.3/?/init.lua;#{luapath}/share/lua/5.3/lxp/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        if r.name == "lua-zlib"
          # https://github.com/brimworks/lua-zlib/commit/08d6251700965
          mv "lua-zlib-1.1-0.rockspec", "lua-zlib-1.2-0.rockspec"
          system "luarocks", "make", "#{r.name}-#{r.version}-0.rockspec", "--tree=#{luapath}",
                             "ZLIB_DIR=#{Formula["zlib"].opt_prefix}"
        elsif r.name == "luaexpat"
          system "luarocks", "build", r.name, "--tree=#{luapath}", "EXPAT_DIR=#{Formula["expat"].opt_prefix}"
        elsif r.name == "luasec"
          system "luarocks", "build", r.name, "--tree=#{luapath}", "OPENSSL_DIR=#{Formula["openssl@1.1"].opt_prefix}"
        else
          system "luarocks", "build", r.name, "--tree=#{luapath}"
        end
      end
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-system-luarocks",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (libexec/"bin").install bin/"sile"
    (bin/"sile").write <<~EOS
      #!/bin/bash
      export LUA_PATH="#{ENV["LUA_PATH"]};;"
      export LUA_CPATH="#{ENV["LUA_CPATH"]};;"
      "#{libexec}/bin/sile" "$@"
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
