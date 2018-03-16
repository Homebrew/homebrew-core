class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.21/stone_soup-0.21.1.tar.xz"
  sha256 "4aa309cf27ed1df56bb24be7e07099d3e2b47f9f0bc9d53d2377849a42ccbee3"

  bottle do
    sha256 "5f7b2cd8ee4e2c0b08a4ef9c0e6935395062133379eac64df21cdf5af2320505" => :high_sierra
    sha256 "c27d34ef368192a7ba8f851224d0daadd5c7f6df626e8560d54fb07450293e5f" => :sierra
    sha256 "daa52de0abc98a3d3143239edea0d407d8847e6d8fc3bd5231e7e2df1cf68658" => :el_capitan
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
