class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.12.0/sile-0.12.0.tar.xz"
  sha256 "c983a2b32d171ba392191eb29de2c3b433452d6cb514f270b17a7b3889fb6de6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d81611b4aac21e41508e2b4e0dbda0bc60a167465bf279b228b28e06df6c47c1"
    sha256 cellar: :any,                 arm64_big_sur:  "46ab35a88b16fd67f7fbe20e6241b1d51457ec3a06f2ff32aac804b40a0f7d94"
    sha256 cellar: :any,                 monterey:       "f718a578c47d40862b89f8c1c01ee39426d74e5eaabd1c6a2fe3d58702a48dc7"
    sha256 cellar: :any,                 big_sur:        "577a2fb134f9d238f97e4ab479991546417bd22d644e78a02f2c6f4b4301b58b"
    sha256 cellar: :any,                 catalina:       "c53f0f67e11a4c24c0bb6b5b27c00725ebc0497135785220dbef8971d015c5b7"
    sha256 cellar: :any,                 mojave:         "4dd937145f1e4ff23d779b8e25bcff230fe288da76825b622de7e80a44947426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59653464acc2cf9ed9f230bfd962e38c144b68bf3197f0dc2a9f46cd93f0b6a8"
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

  # depends on `luasocket`
  resource "luasec" do
    url "https://luarocks.org/manifests/brunoos/luasec-1.0.1-1.src.rock"
    sha256 "0e91f9686ccda7d373d74518da85d22f678a1b0de35e38b4a444041eba53040d"
  end

  resource "penlight" do
    url "https://luarocks.org/manifests/tieske/penlight-1.11.0-1.src.rock"
    sha256 "4bc3e5a5869313a326fe39f23a6d02c4e13d1780cb4559f0aed04c414b1297cf"
  end

  # Depends on luafilesystem and penlight
  resource "cassowary" do
    url "https://luarocks.org/manifests/simoncozens/cassowary-2.3.1-2.src.rock"
    sha256 "bf2ac4c04999402aab9bfa3b38868514f625a9e79c6884aa724b9560714aa500"
  end

  resource "luautf8" do
    url "https://luarocks.org/manifests/xavier-wang/luautf8-0.1.3-1.src.rock"
    sha256 "88c456bc0f00d28201b33551d83fa6e5c3ae6025aebec790c37afb317290e4fa"
  end

  resource "vstruct" do
    url "https://luarocks.org/manifests/deepakjois/vstruct-2.1.1-1.src.rock"
    sha256 "fcfa781a72b9372c37ee20a5863f98e07112a88efea08c8b15631e911bc2b441"
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
    if OS.linux?
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
