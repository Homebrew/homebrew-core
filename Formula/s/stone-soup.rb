class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/refs/tags/0.30.1.tar.gz"
  sha256 "f7f793271eab06822b9cb3936da54a1cbe759b471347088a4d76052ac8947597"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "26b055e3f4e4eed561cd8c3d506f90cee8b866fb2f3e247c8cf9bb1953f7d7c8"
    sha256 arm64_ventura:  "81fb0b75f6b95943d5228d995da9787d98b1acd5b904e1b4e24c0c381c8c5566"
    sha256 arm64_monterey: "990fa69c59b08e3c22dbdf73727ca874bb42e7274a72cdbb8070246a13eca08c"
    sha256 sonoma:         "8b4a994e9695088638e27371d28855aa00a5f2e5589ac6a123c70c2151141f5e"
    sha256 ventura:        "f762f4d55d01014cc2f132571ff9be7d3a48d8555ea7022920ac8c5c240ab46f"
    sha256 monterey:       "40b98f49f5cadf912662b2c1a2817e1864fe7e2fe934d4e539df5230d2a6e090"
    sha256 x86_64_linux:   "96c7c2b5e6d0870feb21bf58c3c4943e18334753e2d8b87445643f9b72623d26"
  end

  # Only supports Lua 5.1 and doesn't work with LuaJIT 2.1 (needs older 2.0).
  # Issues relating to using newer Lua are closed so doesn't seem planned to update,
  # e.g. https://github.com/crawl/crawl/issues/1829#issuecomment-799492138
  disable! date: "2024-02-15", because: "uses deprecated `lua@5.1`"

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
