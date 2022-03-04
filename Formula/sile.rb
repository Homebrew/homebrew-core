class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.12.4/sile-0.12.4.tar.xz"
  sha256 "228faec0592541e373e7a4e4145bdcba60252df08f7c5f6fb4e573c5fbc186d8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8279353c05dfc2f4074e20c61eef423423a274f540bd0a1a4aa50eefef375952"
    sha256 cellar: :any,                 arm64_big_sur:  "eb2ad36066f7264d49e7f2ea9b0cd7740e04e02d8e373d6c8af9c7a51d6f9ff6"
    sha256 cellar: :any,                 monterey:       "4b8bc8d28e4cc9390088c319b6109b62af3cdaa1c859bd184fe97e3343627432"
    sha256 cellar: :any,                 big_sur:        "448901eb24f1201c194f256913eab150d94d6420fa4020c333a2cec42fd5b646"
    sha256 cellar: :any,                 catalina:       "b146315d1ad948dad4b355154a3d770caed2cb11b876f23d8b750c3b83fd1b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73bc40eb1efd2396458f7bea974d1e306264ffcc650460bf0f12facf88553cae"
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
    url "https://luarocks.org/manifests/tieske/penlight-1.12.0-1.src.rock"
    sha256 "99e2d88d5539901989f785100c8d216ef8e9461e08f93a850e9ea6abc9952927"
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
