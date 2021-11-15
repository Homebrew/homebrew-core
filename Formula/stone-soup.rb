class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.27.1.tar.gz"
  sha256 "062f1285852fced23ecb2f272ad132467e12e7e251e02aaa84f37280b55ba63e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "089093ea13f1237329dc6c762a7df469b4dcf734c8a611244b4f2526c428b947"
    sha256 arm64_big_sur:  "0a30fa05afe4133864ff9d34ac0c178891e4039eb875c049c667f6130950142d"
    sha256 monterey:       "7831442ff2da48ecffa3473c359183fadbe5703d208ab4d938f6b5fb3c503cb5"
    sha256 big_sur:        "b59a64c7a12efba902fea1f6d3380cbb44681db72fa201d9a43b416f82c5da79"
    sha256 catalina:       "068b36da3eceee5d209883187db48845f4dd4e2c3b6c2c71ae216d4c1060a24d"
    sha256 mojave:         "6efef64444104587d0066d3ad1794531eed88017080016d4927c2248558d2af4"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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
