class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.30.0.tar.gz"
  sha256 "a4ba0d5a6fcf9bb1ad57b6a116f5d577b7ee9dac33d90448525a1061207a6abf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "4228564c6c264ed39799173c14522277bfefaea30ba9d09aad5c11840f26c090"
    sha256 arm64_monterey: "3e8dc08e1e0b50830ce072617766ae2c98a0370b035914a148d0cffd566f5e07"
    sha256 arm64_big_sur:  "9f6c0948dc573f602ec842e6396c0a2a577aea1966c076fedf0e482ee208ba29"
    sha256 ventura:        "4737ec8e0cebccfa4e1fc6b45dc776bed95458458401d1f1c71b257d9cbfb1e6"
    sha256 monterey:       "0f18f8e878b7cb52dfe622c39669e7c08324a409d9b9b0a1afc400604a5dfdcc"
    sha256 big_sur:        "a9adf20df5a66ef15305604bd4eb6d10e136bc599993bf74f027910939c0b75c"
    sha256 x86_64_linux:   "24eedc5bc310a9e589acde126734c8eb51be741321d2ff5210b90dc61c52fa71"
  end

  # Only supports Lua 5.1 and doesn't work with LuaJIT 2.1 (needs older 2.0).
  # Issues relating to using newer Lua are closed so doesn't seem planned to update,
  # e.g. https://github.com/crawl/crawl/issues/1829#issuecomment-799492138
  deprecate! date: "2023-02-12", because: "uses deprecated `lua@5.1`"

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pyyaml" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  fails_with gcc: "5"

  def install
    ENV.cxx11

    cd "crawl-ref/source" do
      File.write("util/release_ver", version.to_s)
      args = %W[
        prefix=#{prefix}
        DATADIR=data
        NO_PKGCONFIG=
        BUILD_ZLIB=
        BUILD_SQLITE=
        BUILD_FREETYPE=
        BUILD_LIBPNG=
        BUILD_LUA=
        BUILD_SDL2=
        BUILD_SDL2MIXER=
        BUILD_SDL2IMAGE=
        BUILD_PCRE=
        USE_PCRE=y
      ]

      unless OS.mac?
        args += %W[
          CFLAGS=-I#{Formula["pcre"].opt_include}
          LDFLAGS=-ldl
        ]
      end

      # FSF GCC doesn't support the -rdynamic flag
      args << "NO_RDYNAMIC=y" if ENV.compiler != :clang

      # The makefile has trouble locating the developer tools for
      # CLT-only systems, so we set these manually. Reported upstream:
      # https://crawl.develz.org/mantis/view.php?id=7625
      #
      # On 10.9, stone-soup will try to use xcrun and fail due to an empty
      # DEVELOPER_DIR
      if OS.mac?
        devdir = MacOS::Xcode.prefix.to_s
        devdir += "/" unless MacOS::Xcode.installed?

        args += %W[
          DEVELOPER_DIR=#{devdir}
          SDKROOT=#{MacOS.sdk_path}
          SDK_VER=#{MacOS.version}
        ]
      end

      system "make", "install", *args
    end
  end

  test do
    output = shell_output("#{bin}/crawl --version")
    assert_match "Crawl version #{version}", output
  end
end
