class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://www.sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.10.15/sile-0.10.15.tar.xz"
  sha256 "49b55730effd473c64a8955a903e48f61c51dd7bb862e6d5481193218d1e3c5c"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_big_sur: "72d3d5b07f05e63fa46905ac01d0ca3b43dd7243a7394cf6d049687f496dfd72"
    sha256 big_sur:       "f60d2f9eb9682c05e2c28e2060cd03a3ab3c7340a64e27d5734179788efce142"
    sha256 catalina:      "173bedc8deef0b383b42c7f7115cb9ca673d8a614b5accdedbde7b1b469be2cd"
    sha256 mojave:        "53fbb1d6190196ad6b7d4a4970b3d1872dc104ac53a9661f1071cd35bb751e53"
  end

  head do
    url "https://github.com/sile-typesetter/sile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "openssl@1.1"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  resource "stdlib" do
    url "https://luarocks.org/manifests/gvvaughan/stdlib-41.2.2-1.src.rock"
    sha256 "67eadaccbb2b6037ea70129f9616da49eaeeaf1477652a8e2cc77740286531cf"
  end

  resource "bit32" do
    url "https://luarocks.org/manifests/siffiejoe/bit32-5.3.5.1-1.src.rock"
    sha256 "0e273427f2b877270f9cec5642ebe2670242926ba9638d4e6df7e4e1263ca12c"
  end

  resource "linenoise" do
    url "https://luarocks.org/manifests/hoelzro/linenoise-0.9-1.rockspec"
    sha256 "e4f942e0079092993832cf6e78a1f019dad5d8d659b9506692d718d0c0432c72"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  # Depends on lpeg
  resource "cosmo" do
    url "https://luarocks.org/manifests/mascarenhas/cosmo-16.06.04-1.src.rock"
    sha256 "9c83d50c8b734c0d405f97df9940ddb27578214033fd0e3cfc3e7420c999b9a9"
  end

  resource "lua_cliargs" do
    url "https://luarocks.org/manifests/amireh/lua_cliargs-3.0-2.src.rock"
    sha256 "3c79981292aab72dbfba9eb5c006bb37c5f42ee73d7062b15fdd840c00b70d63"
  end

  resource "lua-zlib" do
    url "https://luarocks.org/manifests/brimworks/lua-zlib-1.2-1.rockspec"
    sha256 "3c61e946b5a1fb150839cd155ad6528143cdf9ce385eb5f580566fb2d25b37a3"
  end

  resource "luaexpat" do
    url "https://luarocks.org/manifests/tomasguisasola/luaexpat-1.3.3-1.src.rock"
    sha256 "b55908fcd7df490a59aab25284460add8283f1c6b94ab584900fe3e49775172a"
  end

  resource "luaepnf" do
    url "https://luarocks.org/manifests/siffiejoe/luaepnf-0.3-2.src.rock"
    sha256 "7abbe5888abfa183878751e4010239d799e0dfca6139b717f375c26292876f07"
  end

  resource "luafilesystem" do
    url "https://luarocks.org/manifests/hisham/luafilesystem-1.8.0-1.src.rock"
    sha256 "576270a55752894254c2cba0d49d73595d37ec4ea8a75e557fdae7aff80e19cf"
  end

  resource "luarepl" do
    url "https://luarocks.org/manifests/hoelzro/luarepl-0.9-1.rockspec"
    sha256 "1fc5b25e5dfffe1407537b58f7f118379ed3e86e86c09c0b9e4893ddada20990"
  end

  resource "luasocket" do
    url "https://luarocks.org/manifests/luasocket/luasocket-3.0rc1-2.src.rock"
    sha256 "3882f2a1e1c6145ceb43ead385b861b97fa2f8d487e8669ec5b747406ab251c7"
    version "3.0rc1-2"
  end

  resource "penlight" do
    url "https://luarocks.org/manifests/tieske/penlight-1.9.2-1.src.rock"
    sha256 "49e7778ba84a5a8ac67fc2a30357f0975fe11241d7cc86df05a5abb18071d5fb"
  end

  # Depends on luafilesystem and penlight
  resource "cassowary" do
    url "https://luarocks.org/manifests/simoncozens/cassowary-2.2-1.src.rock"
    sha256 "feab102d06f57998915a5945e6742246b5955bb65a69d45c2e572d59e6874f51"
  end

  resource "luautf8" do
    url "https://luarocks.org/manifests/xavier-wang/luautf8-0.1.3-1.src.rock"
    sha256 "88c456bc0f00d28201b33551d83fa6e5c3ae6025aebec790c37afb317290e4fa"
  end

  resource "vstruct" do
    url "https://luarocks.org/manifests/deepakjois/vstruct-2.1.1-1.src.rock"
    sha256 "fcfa781a72b9372c37ee20a5863f98e07112a88efea08c8b15631e911bc2b441"
  end

  # Install luasec last, as this breaks installing other resources for now
  # https://github.com/luarocks/luarocks/issues/1302
  # When this is resolved, move back between `luarepl` and `luasocket`
  resource "luasec" do
    url "https://luarocks.org/manifests/brunoos/luasec-1.0-1.src.rock"
    sha256 "b7e18f475c64896fe4921d367adabae765914f7526a68487a5fa6831040e7138"
  end

  def install
    lua = Formula["lua"]
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

    zlib_dir = expat_dir = "#{MacOS.sdk_path_if_needed}/usr"
    on_linux do
      zlib_dir = Formula["zlib"].opt_prefix
      expat_dir = Formula["expat"].opt_prefix
    end

    args = %W[
      ZLIB_DIR=#{zlib_dir}
      EXPAT_DIR=#{expat_dir}
      OPENSSL_DIR=#{Formula["openssl@1.1"].opt_prefix}
      --tree=#{luapath}
      --lua-dir=#{lua.opt_prefix}
    ]

    resources.each do |r|
      r.stage do
        rock = Pathname.pwd.children(false).first
        unpack_dir = Utils.safe_popen_read("luarocks", "unpack", rock).split("\n")[-2]

        spec = "#{r.name}-#{r.version}.rockspec"
        spec = "cassowary-scm-0.rockspec" if r.name == "cassowary"
        cd(unpack_dir) { system "luarocks", "make", *args, spec }
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

    env = {
      LUA_PATH:  "#{ENV["LUA_PATH"]};;",
      LUA_CPATH: "#{ENV["LUA_CPATH"]};;",
    }

    (libexec/"bin").install bin/"sile"
    (bin/"sile").write_env_script libexec/"bin/sile", env
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
