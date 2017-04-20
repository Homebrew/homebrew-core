class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/stone_soup-0.19.5.tar.xz"
  # Note the mirror will return 404 until the version becomes outdated.
  mirror "https://crawl.develz.org/release/0.19/stone_soup-0.19.5.tar.xz"
  sha256 "3c34787cf752d48789102e170ff7360ddcdd79bd55a4e0feb9894e517b274069"

  bottle do
    sha256 "4f89fb7977808eae1f0d2e6e4314a732ad2087426ed9997a68959a3f15be2604" => :sierra
    sha256 "eed4194a19fbb4d3652ece83aac7c161ae8fa58c4db90fb886fce53a39bccafe" => :el_capitan
    sha256 "dd817ca11daadcef30e964a6d80dc8f150cfb32837cdba605def22fb38121265" => :yosemite
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
