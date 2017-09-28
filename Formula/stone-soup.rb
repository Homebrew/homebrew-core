class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.20/stone_soup-0.20.1.tar.xz"
  sha256 "77d238bd859166e09bbf56127997f810d1c9794e1cf4a0d1edc0687b6f194dee"

  bottle do
    sha256 "f540d3696af53cdc02e139290a35bd81857f830878b0ba60fbe2546d7ee7b975" => :high_sierra
    sha256 "5a858765714fc0241e108a99de4fd738e9cd7ea0f80a3cb06089f51120f305a3" => :sierra
    sha256 "9c0771911aef3eff5695cd1696839029a6625c6b3e645db7728f3976658a44ac" => :el_capitan
  end

  option "with-tiles", "Enable graphic tiles and sound"
  option "without-lua@5.1", "Disable Lua bindings for user scripts"

  depends_on "pkg-config" => :build
  depends_on "lua@5.1" => :recommended
  depends_on "pcre"

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_mixer"
    depends_on "sdl2_image"
    depends_on "libpng"
    depends_on "freetype"
  end

  needs :cxx11

  def install
    ENV.cxx11

    cd "source" do
      args = %W[
        prefix=#{prefix}
        DATADIR=data
        NO_PKGCONFIG=
        BUILD_ZLIB=
        BUILD_SQLITE=yes
        BUILD_FREETYPE=
        BUILD_LIBPNG=
        BUILD_SDL2=
        BUILD_SDL2MIXER=
        BUILD_SDL2IMAGE=
        BUILD_PCRE=
        USE_PCRE=y
      ]
      if build.with? "tiles"
        inreplace "Makefile", "contrib/install/$(ARCH)/lib/libSDL2main.a", ""
        args << "TILES=y"
        args << "SOUND=y"
      end

      if build.with? "lua@5.1"
        args << "BUILD_LUA=y"
      else
        args << "NO_LUA_BINDINGS=y"
      end

      # FSF GCC doesn't support the -rdynamic flag
      args << "NO_RDYNAMIC=y" unless ENV.compiler == :clang

      # The makefile has trouble locating the developer tools for
      # CLT-only systems, so we set these manually. Reported upstream:
      # https://crawl.develz.org/mantis/view.php?id=7625
      #
      # On 10.9, stone-soup will try to use xcrun and fail due to an empty
      # DEVELOPER_DIR
      devdir = MacOS::Xcode.prefix.to_s
      devdir += "/" if MacOS.version >= :mavericks && !MacOS::Xcode.installed?

      system "make", "install",
        "DEVELOPER_DIR=#{devdir}", "SDKROOT=#{MacOS.sdk_path}",
        # stone-soup tries to use `uname -m` to determine build -arch,
        # which is frequently wrong on OS X
        "SDK_VER=#{MacOS.version}", "MARCH=#{MacOS.preferred_arch}",
        *args
    end
  end

  test do
    assert shell_output("#{bin}/crawl --version").start_with? "Crawl version #{version}"
  end
end
