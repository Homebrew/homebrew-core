class StoneSoup < Formula
  include Language::Python::Virtualenv

  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.29.1.tar.gz"
  sha256 "e8ff1d09718ab3cbff6bac31651185b584c9eea2c9b6f42f0796127ca5599997"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "f938d2a002197e0987e3b33fa1760de689a2d5451b64c105896f46de483d4d2a"
    sha256 arm64_big_sur:  "e11b33c64f4d6b2521579df74f1ff6f1e66784d64fa3986b003d2905581640c4"
    sha256 monterey:       "9e5d6568c2bb2e462dd87ce544d755d8ea56a36862e9b2c642e7a6ce82570298"
    sha256 big_sur:        "d04f0c248b61b944239b8fd71e3443009096dda4e119a65ceeb4c7d74fdb5c73"
    sha256 catalina:       "8c22ced2e5a55051b77fdbf1cb9ead71a3e2a8ce26c3d903a958c72b0c759628"
    sha256 x86_64_linux:   "5b3baa0ae9ca696c896ce8cea85f34289078791a86c753404d5545604b8314d1"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  fails_with gcc: "5"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    python3 = "python3.10"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor"/Language::Python.site_packages(python3)

    venv = virtualenv_create(buildpath/"vendor", python3)
    venv.pip_install resource("PyYAML")

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
      args << "NO_RDYNAMIC=y" unless ENV.compiler == :clang

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
