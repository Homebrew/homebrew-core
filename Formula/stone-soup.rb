class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.22/stone_soup-0.22.0.tar.xz"
  sha256 "02e36ccc458747e89ab84835f6dd7df554e8e40537397797c5bb61a4d376597d"

  bottle do
    sha256 "098f4c729890622a1f75e144a2ea87b3ad44c4f148ced01e224b93edfc52101f" => :mojave
    sha256 "1f2fd929557b2eb7f8b9a8091479210c94b360d9a69aa1cc79f3712daad9a4d8" => :high_sierra
    sha256 "90d1d10bfb4fd49ec62fd40aebeb622312d603ffd20553f18e5473725767dde3" => :sierra
    sha256 "3690a7a849debe2f941a948ab4fbeb017985bdd163eb973841e201fb21532f0c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lua@5.1"
  depends_on "pcre"

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
    output = shell_output("#{bin}/crawl --version")
    assert_match "Crawl version #{version}", output
  end
end
