class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.13.1/sile-0.13.1.tar.xz"
  sha256 "bec374b5c95b0fb763c6976a25986341b836ac187fe6f4adb8f306b45ff3bb26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0b0f6bc217c3b4beb0c0b76b209ad7d77cf7390b32e9f45e532404bfb4e8c11"
    sha256 cellar: :any,                 arm64_big_sur:  "8aff274a17dffaafb9e729663a0ee1314820b3036c8f2cce525b8700ed91e82b"
    sha256 cellar: :any,                 monterey:       "89ca7232f6ef8ea9053bb51b0e0891fdbf06f08bbf3b89d25d401d301c1d1860"
    sha256 cellar: :any,                 big_sur:        "48b466cfa705153d1731feb973ce08fd5812933dd322bdf7be0317d9de7316dc"
    sha256 cellar: :any,                 catalina:       "5c763013b45108c6e48f9c4364ded69cb4f4b8771be9198491e231e166882bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a4a46a5a545ecb868eeca90b44fd1e4f768d5e7bab65c2b8e7f7938ca0f56d"
  end

  head do
    url "https://github.com/sile-typesetter/sile.git", branch: "master"

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

  resource "loadkit" do
    url "https://luarocks.org/manifests/leafo/loadkit-1.1.0-1.src.rock"
    sha256 "6a631cb08a78324cb5f92b1cb8e2f59502d7113407d0d9b0d95045d8a4febccb"
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

  # depends on lpeg
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
    url "https://luarocks.org/manifests/lunarmodules/luasocket-3.0.0-1.src.rock"
    sha256 "63fd2dd18dfe242ca5bcc1203839e86a9c8936261a9ca9f3200f2deab431da88"
  end

  # depends on luasocket
  resource "luasec" do
    url "https://luarocks.org/manifests/brunoos/luasec-1.1.0-1.src.rock"
    sha256 "534e16ead4bcddb9d536869fdaf0cac049c8bc710a01749f99df3b63b68e2e24"
  end

  # depends on luafilesystem
  resource "penlight" do
    url "https://luarocks.org/manifests/tieske/penlight-1.12.0-2.src.rock"
    sha256 "bcf2b591fb0ff650007211a99256c15acbfb927a7e7e779cae15ae52cb8d6bea"
  end

  # depends on penlight
  resource "cldr" do
    url "https://luarocks.org/manifests/alerque/cldr-0.2.0-0.src.rock"
    sha256 "965e2917b2d06b1c416935be4d7a59aa438e9bad5015b2aefd055f0efdd79758"
  end

  # Depends on cldr, luaepnf, penlight
  resource "fluent" do
    url "https://luarocks.org/manifests/alerque/fluent-0.2.0-0.src.rock"
    sha256 "ea915c689dfce2a7ef5551eb3c09d4620bae60a51c20d48d85c14b69bf3f28ba"
  end

  # Depends on luafilesystem, penlight
  resource "cassowary" do
    url "https://luarocks.org/manifests/simoncozens/cassowary-2.3.2-1.src.rock"
    sha256 "2d3c3954eeb8b5da1d7b1b56c209ed3ae11d221220967c159f543341917ce726"
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
