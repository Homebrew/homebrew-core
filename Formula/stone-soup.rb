class StoneSoup < Formula
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
    rebuild 1
    sha256 arm64_monterey: "ac083b40432b38b3a0df7d35b15e3af9b53a41a6113806dd18ce6b075316923e"
    sha256 arm64_big_sur:  "28a5163e873774752907af82fc0dcdbfd74a2331762d80bd6c061510819fb6d1"
    sha256 monterey:       "7d20dd85eb1ecb488e5f241bc700d5b569154fd804642e86a4662a35b8834ed3"
    sha256 big_sur:        "e2572a4c65ce87835e6759d7c545b33b0468f85dfd0eff73ac05b00344a799f9"
    sha256 catalina:       "2c1a00f2bd5c458d426ae7c79f39d7058d13c98bddca6b904b068a8f8ec0c926"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "lua@5.1"
  depends_on "pcre"
  depends_on "sqlite"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
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
