class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.27.0.tar.gz"
  sha256 "94b1a42bf5814b508e40358b0ba54eda18932b00192d77a802e07cdd939cb545"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "58bb2a177470567d04ac5bbd152aaef4e32d10d106b379b840a6e9bca7645e75"
    sha256 big_sur:       "5f2aad19120c3473f4ed39cbebcc89841ebd79b5021a2bf8b6cfd5d7dce9bf14"
    sha256 catalina:      "acc00ee3ec1a27af659abf91ffbf017f9941fe4ffd8341aa5e052b1a4d0c82a6"
    sha256 mojave:        "3c8003eeef6d8e081581061d6c7004b6232306fdbf912f76f91e2d10616d0723"
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
