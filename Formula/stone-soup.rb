class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.22/stone_soup-0.22.2.tar.xz"
  sha256 "7b9aaeb9d4693697726b3daacef99be54ae0e71382ec5205a3dae80d041f99e9"

  bottle do
    sha256 "000858caed6adc83af07e58ae18ae965068467eda9bc55fa857e67b11758aaf6" => :mojave
    sha256 "9c2728c5e7e0aa9cd005dd88be988c9ce0fd442c2fbf4dfbcd0889ddc44a77e9" => :high_sierra
    sha256 "6ff5f2ccb4d81ee521d8fd2b86a33c8f382b9d56ac87ec8cf3b15eae69583d64" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lua@5.1"
  depends_on "pcre"

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
        BUILD_LUA=y
        BUILD_SDL2=
        BUILD_SDL2MIXER=
        BUILD_SDL2IMAGE=
        BUILD_PCRE=
        USE_PCRE=y
      ]

      # FSF GCC doesn't support the -rdynamic flag
      args << "NO_RDYNAMIC=y" unless ENV.compiler == :clang

      # The makefile has trouble locating the developer tools for
      # CLT-only systems, so we set these manually. Reported upstream:
      # https://crawl.develz.org/mantis/view.php?id=7625
      #
      # On 10.9, stone-soup will try to use xcrun and fail due to an empty
      # DEVELOPER_DIR
      devdir = MacOS::Xcode.prefix.to_s
      devdir += "/" unless MacOS::Xcode.installed?

      system "make", "install",
        "DEVELOPER_DIR=#{devdir}", "SDKROOT=#{MacOS.sdk_path}",
        # stone-soup tries to use `uname -m` to determine build -arch,
        # which is frequently wrong on OS X
        "SDK_VER=#{MacOS.version}", "MARCH=#{MacOS.preferred_arch}",
        *args
    end
  end

  test do
    output = shell_output("#{bin}/crawl --version")
    assert_match "Crawl version #{version}", output
  end
end
