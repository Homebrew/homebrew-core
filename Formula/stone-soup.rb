class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.26.0.tar.gz"
  sha256 "6306c835246057bf91b6690fde14c2c3433ebe1d526876f96c46fab6dc109d45"
  license "GPL-2.0"

  livecheck do
    url "https://crawl.develz.org/download.htm"
    regex(/Stable.*?>v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 "0023d33f5c5205df2d97ed298dc40155d90db29f986bf58825e1f8c33a4f5375" => :big_sur
    sha256 "0985f51f3dec4da7085b6b8c4c28ad650f0abfcca0ff93b2f30b15b8bb408cba" => :arm64_big_sur
    sha256 "b1f22b829dd8fd185559988b5f77519b388b9bb928ee4c8ab43b904898d3e07c" => :catalina
    sha256 "73e93b52661b35d99cde73d7b9ce3ed655cd4da4389b2bed582f2c791745b9ed" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("PyYAML").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

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
        "SDK_VER=#{MacOS.version}", *args
    end
  end

  test do
    output = shell_output("#{bin}/crawl --version")
    assert_match "Crawl version #{version}", output
  end
end
