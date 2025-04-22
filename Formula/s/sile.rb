class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https://sile-typesetter.org"
  url "https://github.com/sile-typesetter/sile/releases/download/v0.15.12/sile-0.15.12.tar.zst"
  sha256 "a3234111d56bb22f0cba2608954ec88df260eb4772f054ed29770912003ec8a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eca1e70dd844c9facaedb981b388afb6a238fba2f953b60dcf82a9dc00daf0fb"
    sha256 cellar: :any,                 arm64_sonoma:  "336bc3d0f83537822e1b9613d0271246cb6f61a7e80b911f5aec23509662813c"
    sha256 cellar: :any,                 arm64_ventura: "9776105f8da8dbefa26535ca9dd15ac771476b5a7a1d7320f038ddde52d79962"
    sha256 cellar: :any,                 sonoma:        "89d04ca5e3ec6e92e79959f9a16a329ad6b47db644932f75c2024f2d3d0396dc"
    sha256 cellar: :any,                 ventura:       "44367b55c868bd3659d507654a101812a2b4ea4876b9ff76bcef05aa8d27528d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706444ee18db2eb49fe44044c9fbc170dd91180b3a80c5ab533658dcd03731b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570ca957d702a09bb5901515a9216c72b2a770da6064bf8d5d276c1558fb3ad5"
  end

  head do
    url "https://github.com/sile-typesetter/sile.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "poppler" => :build
  depends_on "rust" => :build

  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "libpng"
  depends_on "luajit"
  depends_on "luarocks"
  depends_on "openssl@3"

  uses_from_macos "unzip" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
  end

  resource "compat53" do
    url "https://luarocks.org/manifests/lunarmodules/compat53-0.14.3-1.rockspec"
    sha256 "16218188112c20e9afa9e9057f753d29d7affb10fe3fb2ac74cab17c6de9a030"
  end

  resource "linenoise" do
    url "https://luarocks.org/manifests/hoelzro/linenoise-0.9-1.rockspec"
    sha256 "e4f942e0079092993832cf6e78a1f019dad5d8d659b9506692d718d0c0432c72"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.1.0-1.src.rock"
    sha256 "6637fcf4d3ddef7be490a2f0155bd2dcd053272d1bb78c015498709ef9fa75dd"
  end

  resource "loadkit" do
    url "https://luarocks.org/manifests/leafo/loadkit-1.1.0-1.src.rock"
    sha256 "6a631cb08a78324cb5f92b1cb8e2f59502d7113407d0d9b0d95045d8a4febccb"
  end

  resource "lua_cliargs" do
    url "https://luarocks.org/manifests/lunarmodules/lua_cliargs-3.0.2-1.src.rock"
    sha256 "a2dfbd3f0236eaf4b0421dbd06a631d92b550335eb263b7283e1161a6e90d92e"
  end

  resource "lua-zlib" do
    url "https://luarocks.org/manifests/brimworks/lua-zlib-1.2-2.rockspec"
    sha256 "adc3e279ce67fb477ce7bf88cfb87607491d1c50d9c785b1567066c353f192f9"
  end

  # This resource cannot be updated
  # Ref: https://github.com/Homebrew/homebrew-core/pull/128136#issuecomment-1505583956
  resource "luaexpat" do
    url "https://luarocks.org/manifests/lunarmodules/luaexpat-1.4.1-1.src.rock"
    sha256 "b2b31f62fd09252d7ec0218d083cf9b8d9fc6a20f4594559f96649beee172233"
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
    url "https://luarocks.org/manifests/hoelzro/luarepl-0.10-1.rockspec"
    sha256 "a3a16e6e5e84eb60e2a5386d3212ab37c472cfe3110d75642de571a29da4ed8b"
  end

  resource "luasocket" do
    url "https://luarocks.org/manifests/lunarmodules/luasocket-3.1.0-1.src.rock"
    sha256 "f4a207f50a3f99ad65def8e29c54ac9aac668b216476f7fae3fae92413398ed2"
  end

  # depends on luasocket
  resource "luasec" do
    url "https://luarocks.org/manifests/brunoos/luasec-1.3.2-1.src.rock"
    sha256 "f93bf9927bd34a5d4f897f4488b285a12bee89c0e7d54b3b36dfcbf43a7ad4e5"
  end

  # depends on luafilesystem
  resource "penlight" do
    url "https://luarocks.org/manifests/tieske/penlight-1.14.0-2.src.rock"
    sha256 "f36affa14fb43e208a59f2e96d214f774b957bcd05d9c07ec52b39eac7f4a05d"
  end

  # depends on penlight
  resource "cldr" do
    url "https://luarocks.org/manifests/alerque/cldr-0.3.0-0.src.rock"
    sha256 "2efc94c10b659ab1009dc191f1694bd332c34379f87f4dd21f827d0e6948ed6d"
  end

  # depends on cldr, luaepnf, penlight
  resource "fluent" do
    url "https://luarocks.org/manifests/alerque/fluent-0.2.0-0.src.rock"
    sha256 "ea915c689dfce2a7ef5551eb3c09d4620bae60a51c20d48d85c14b69bf3f28ba"
  end

  # depends on luafilesystem, penlight
  resource "cassowary" do
    url "https://luarocks.org/manifests/simoncozens/cassowary-2.3.2-1.src.rock"
    sha256 "2d3c3954eeb8b5da1d7b1b56c209ed3ae11d221220967c159f543341917ce726"
  end

  resource "luautf8" do
    url "https://luarocks.org/manifests/xavier-wang/luautf8-0.1.6-1.src.rock"
    sha256 "37901bc127c4afe9f611bba58af7b12eda6599fc270e1706e2f767807dfacd82"
  end

  resource "vstruct" do
    url "https://luarocks.org/manifests/deepakjois/vstruct-2.1.1-1.src.rock"
    sha256 "fcfa781a72b9372c37ee20a5863f98e07112a88efea08c8b15631e911bc2b441"
  end

  def install
    lua = Formula["luajit"]
    luaversion = "5.1"
    luapath = libexec/"vendor"

    paths = %W[
      #{luapath}/share/lua/#{luaversion}/?.lua
      #{luapath}/share/lua/#{luaversion}/?/init.lua
      #{luapath}/share/lua/#{luaversion}/lxp/?.lua
    ]

    ENV["LUA_PATH"] = "#{paths.join(";")};;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    ENV.prepend "CPPFLAGS", "-I#{lua.opt_include}/luajit-2.1"
    ENV.prepend "LDFLAGS", "-L#{lua.opt_lib}"

    if OS.mac?
      zlib_dir = expat_dir = "#{MacOS.sdk_path_if_needed}/usr"
    else
      zlib_dir = Formula["zlib"].opt_prefix
      expat_dir = Formula["expat"].opt_prefix
    end

    luarocks_args = %W[
      ZLIB_DIR=#{zlib_dir}
      EXPAT_DIR=#{expat_dir}
      OPENSSL_DIR=#{Formula["openssl@3"].opt_prefix}
      --tree=#{luapath}
      --lua-dir=#{lua.opt_prefix}
    ]

    resources.each do |r|
      r.stage do
        rock = Pathname.pwd.children(false).first
        unpack_dir = Utils.safe_popen_read("luarocks", "unpack", rock).split("\n")[-2]
        spec = "#{r.name}-#{r.version}.rockspec"
        cd(unpack_dir) { system "luarocks", "make", *luarocks_args, spec }
      end
    end

    configure_args = %w[
      FCMATCH=true
      --disable-silent-rules
      --disable-static
      --disable-embeded-resources
      --with-system-lua-sources
      --with-system-luarocks
      --with-vendored-luarocks-dir=#{luapath}
    ]

    system "./bootstrap.sh" if build.head?
    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      By default SILE uses the font Gentium Plus to render all documents that do not specifically call for something else. If this font is not available on your system you may encounter errors. Of lower priority depending on your use case, the math typesetting package defaults to using Libertinus Math and the default monospace font is Hack.

      Homebrew does not supply any of these font dependencies in default casks, but they can be added by tapping cask-fonts:
        brew tap homebrew/cask-fonts
        brew install --cask font-gentium-plus
        brew install --cask font-libertinus
        brew install --cask font-hack

      Alternatively you can download and install the fonts yourself:
        https://software.sil.org/gentium/
        https://github.com/alerque/libertinus
        https://sourcefoundry.org/hack/
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
