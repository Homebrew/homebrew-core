class StoneSoup < Formula
  include Language::Python::Virtualenv

  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.28.0.tar.gz"
  sha256 "287f35476d20bbe8aaa3e663140704462b4e304a4e1ed5c2b5da1d273dd1f383"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "739eb63071963e6998243a03592a1c85dbb87b1ae39edbbbd5d4412f887ddcfb"
    sha256 arm64_big_sur:  "5c73e7b489f45806902d011973d91947c9d0af47aa2cea058e81fdfa9b2f15c0"
    sha256 monterey:       "00ebb829ffc8ad6b608e50528ec8b4692f2181efce13c071688c0ebd03012a16"
    sha256 big_sur:        "d68275933552ec851d6e1f06a8528d6d2f6eb3b683e21fa34beaf5f9c5e23c1d"
    sha256 catalina:       "0a5fed8750fcfda5f27efc2a8337e844911454fad521cad6d21e4585211b64a5"
    sha256 x86_64_linux:   "7a6b21ce059ffeaca3fad2ffde77fccc2d030e1f2212f6cf23693a8afbe1ddcf"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    venv = virtualenv_create(buildpath/"vendor", "python3")
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
