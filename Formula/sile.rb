class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://www.sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.10.13/sile-0.10.13.tar.xz"
  sha256 "d207d0ee9749a6da16fa2db217f51d3586955387a132c45423b47eedf8c964a6"
  license "MIT"
  revision 3
  head "https://github.com/sile-typesetter/sile.git", shallow: false

  bottle do
    sha256 "d791ab6a480aabc66efede6487b6c8199527d0d9874249f510f18bf50fdb8443" => :big_sur
    sha256 "cb965e298eeb6f23de84f65c97b6537c2ae5ad1fc55224c3355f77eb28113bb7" => :catalina
    sha256 "f1707b37213ffda7234761238e10a8abb8179c86c3f9b6e02c6d8dd71ffbecc0" => :mojave
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

  resource "bit32" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.tar.gz"
    sha256 "d1ed32f091856f6fffab06232da79c48b437afd4cd89e5c1fc85d7905b011430"
  end

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
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz"
    sha256 "48d66576051b6c78388faad09b70493093264588fcd0f258ddaab1cdd4a15ffe"
  end

  resource "lua_cliargs" do
    url "https://github.com/amireh/lua_cliargs/archive/v2.3-3.tar.gz"
    sha256 "288eea7c12b2e37bb40241c59e592472f835c526cd807ffc3e2fe21def772481"
  end

  resource "lua-zlib" do
    url "https://github.com/brimworks/lua-zlib/archive/v1.2.tar.gz"
    sha256 "26b813ad39c94fc930b168c3418e2e746af3b2e80b92f94f306f6f954cc31e7d"
  end

  resource "luaexpat" do
    url "https://github.com/tomasguisasola/luaexpat/archive/v1.3.3.tar.gz"
    sha256 "a17a0e6ffa6977406b072d67a13ca0e125fad63e1229cec4efcd8d83f1c3eed9"
  end

  resource "luaepnf" do
    url "https://github.com/siffiejoe/lua-luaepnf/archive/v0.3.tar.gz"
    sha256 "57c0ad1917e45c5677bfed0f6122da2baff98117aba05a5e987a0238600f85f9"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
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
    url "https://github.com/brunoos/luasec/archive/v0.9.tar.gz"
    sha256 "6b6b94e8517bf6baf545fad29a2112f9ac7957ad85b4aae8e0727bec77d7a325"
  end

  resource "penlight" do
    url "https://github.com/Tieske/Penlight/archive/1.8.0.tar.gz"
    sha256 "a1a41c5ec82c0459bc0508a0fb1cb56dfaa83a1dd7754d7174b336ad65420d3d"
  end

  resource "stdlib" do
    url "https://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.tar.gz"
    sha256 "42ca25ddcde59f608694a3335d24919a4df4cf6f14ea46c75249561a16c84711"
  end

  resource "vstruct" do
    url "https://github.com/ToxicFrog/vstruct/archive/v2.0.1.tar.gz"
    sha256 "4529ab32691b5f6e3c798ddfac36013d24d7581715dc7a50a77f17bb2d575c13"
  end

  def install
    lua = Formula["lua"]
    luaprefix = lua.opt_prefix
    luaversion = lua.version.major_minor
    luapath = libexec/"vendor"

    paths = %W[
      #{luapath}/share/lua/#{luaversion}/?.lua
      #{luapath}/share/lua/#{luaversion}/?/init.lua
      #{luapath}/share/lua/#{luaversion}/lxp/?.lua
    ]

    ENV["LUA_PATH"] = paths.join(";")
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so"

    ENV.prepend "CPPFLAGS", "-I#{lua.opt_include}/lua"
    ENV.prepend "LDFLAGS", "-L#{lua.opt_lib}"

    resources.each do |r|
      r.stage do
        case r.name
        when "lua-zlib"
          # https://github.com/brimworks/lua-zlib/commit/08d6251700965
          # https://github.com/brimworks/lua-zlib/issues/49
          mv "lua-zlib-1.1-0.rockspec", "lua-zlib-1.2-1.rockspec"

          # rockspec needs to be updated to accommodate lua5.4:
          # https://github.com/brimworks/lua-zlib/pull/50
          # Note that the maintainer prefers the upper bound of `<= 5.4`,
          # so this may lead to subtle breakage if lua5.5 is ever released.
          # https://github.com/brimworks/lua-zlib/pull/51
          # Remove this when `lua-zlib` is updated.
          inreplace "lua-zlib-1.2-1.rockspec" do |s|
            s.gsub! "1.2-0", "1.2-1"
            s.gsub! ", <= 5.3", ""
          end

          system "luarocks", "make",
                             "#{r.name}-#{r.version}-1.rockspec",
                             "ZLIB_DIR=#{Formula["zlib"].opt_prefix}",
                             "--tree=#{luapath}",
                             "--lua-dir=#{luaprefix}"
        when "luaexpat"
          system "luarocks", "build",
                             r.name,
                             "EXPAT_DIR=#{Formula["expat"].opt_prefix}",
                             "--tree=#{luapath}",
                             "--lua-dir=#{luaprefix}"
        when "luasec"
          system "luarocks", "build",
                             r.name,
                             "OPENSSL_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                             "--tree=#{luapath}",
                             "--lua-dir=#{luaprefix}"
        else
          system "luarocks", "build",
                             r.name,
                             "--tree=#{luapath}",
                             "--lua-dir=#{luaprefix}"
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
