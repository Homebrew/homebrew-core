class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://www.sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.10.15/sile-0.10.15.tar.xz"
  sha256 "49b55730effd473c64a8955a903e48f61c51dd7bb862e6d5481193218d1e3c5c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6e4cb6f0234094a58c5acee287639c91aaf6c78a64bc71f9bb98d30f4b6af5fc"
    sha256 cellar: :any, big_sur:       "11d724e8aa83920fd025266027101c546ff300f06cbc91bb71939504aefddfb9"
    sha256               catalina:      "da19d65b1c721bce480847fd2d28d5fd66ba6e16a715a90fc81af681304cf8d0"
    sha256               mojave:        "2e0ae63e6a7a1db891ce18a18fecc5d261168994b239edb298ad68067ff34e29"
  end

  head do
    url "https://github.com/sile-typesetter/sile.git", shallow: false

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
    url "https://github.com/amireh/lua_cliargs/archive/v3.0-2.tar.gz"
    sha256 "971d6f1440a55bdf9db581d4b2bcbf472a301d76f696a0d0ed9423957c7d176e"
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
    url "https://github.com/brunoos/luasec/archive/v1.0.tar.gz"
    sha256 "912bfd2050338895207cf24bc8dd26fa9ebddc34006cb8c33d488156d41ac932"
  end

  resource "penlight" do
    url "https://github.com/Tieske/Penlight/archive/1.9.2.tar.gz"
    sha256 "1094368bd95f84428ce1ce814028f8a73ee6a952e18dfffc5fa05d9ee1f0e486"
  end

  resource "stdlib" do
    url "https://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.tar.gz"
    sha256 "42ca25ddcde59f608694a3335d24919a4df4cf6f14ea46c75249561a16c84711"
  end

  resource "luautf8" do
    url "https://github.com/starwing/luautf8/archive/0.1.3.tar.gz"
    sha256 "208b3423a03a6c2822a2fa6b7cc8092ed7d3c0d792ec12c7cd28d6afaa442e0b"
  end

  resource "vstruct" do
    url "https://github.com/ToxicFrog/vstruct/archive/v2.1.1.tar.gz"
    sha256 "029ae887fc3c59279f378a499741811976d90f9a806569a42f4de80ad349f333"
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
      #!/usr/bin/env sh
      export LUA_PATH="#{ENV["LUA_PATH"]};;"
      export LUA_CPATH="#{ENV["LUA_CPATH"]};;"
      exec "#{libexec}/bin/sile" "$@"
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
