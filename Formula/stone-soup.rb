class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.23/stone_soup-0.23.2.tar.xz"
  sha256 "ebb8fb7c52f5947b23916a903fe2c18693c322132dc4bcef82473d365bc7c11e"

  bottle do
    sha256 "375b560e53b05aba691bda692487df93905bcc67d644e3b5ba52fe1875f8ddb6" => :catalina
    sha256 "38da66978f30d298863a898998973d0bf17fd3267e2cf643cbebff9b731e4579" => :mojave
    sha256 "95393c6616f984316e2ad9021506d02b34a6263cc9ca757524d8e5d3de9acff3" => :high_sierra
    sha256 "a0a1d32f7eb028db7cd7018505d88769c3506ed86cd0a402a44d0de79ce1c63e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "lua@5.1"
  depends_on "pcre"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("PyYAML").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

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
