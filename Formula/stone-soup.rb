class StoneSoup < Formula
  include Language::Python::Virtualenv

  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://github.com/crawl/crawl/archive/0.29.0.tar.gz"
  sha256 "4b32d3c3a07fe969cc1e9d12430b4c143c36e92746b3715ccdb8416720fdc59f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "5f29bd14d6ea825b6ed20307640820829ae92443dcf127f0f22f911a90254871"
    sha256 arm64_big_sur:  "8fdf7354f3124a44f11ead904a85e8d4a6d4c6c4cf0919506949ad63566eedcc"
    sha256 monterey:       "70ce72d4751274fff9c71066b913c4f187cfdd035653edbd165743e8527e75da"
    sha256 big_sur:        "9082d248ff5392a5d361cd640b89be892a1d9671eb9a6f6763c8e101f76d4387"
    sha256 catalina:       "9ec9dda231c396e32294e6bccf6b6a28d65a4709e952caade7c9beae72c34a35"
    sha256 x86_64_linux:   "f969df6fa0bd2a5ac6282e1b81e977c0494acbd1c830a7f6e7c2deadba4df9c8"
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
