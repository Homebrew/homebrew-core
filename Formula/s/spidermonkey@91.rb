class SpidermonkeyAT91 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/91.13.0esr/source/firefox-91.13.0esr.source.tar.xz"
  version "91.13.0"
  sha256 "53be2bcde0b5ee3ec106bd8ba06b8ae95e7d489c484e881dfbe5360e4c920762"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6c8e0991f5644ce8f5ba4978a458da014abcca8ffcc7633ef4f00d45a112e46"
    sha256 cellar: :any,                 arm64_ventura:  "d2482aa0378ab2caedc651ac5affcafbf7f341f570f29fe4fadac00bbb089e7d"
    sha256 cellar: :any,                 arm64_monterey: "bdb1f803fb43029a92439b5855d75cba658b0844e2e4d83180e7f82f7b16218b"
    sha256 cellar: :any,                 sonoma:         "206fa2cdd4e2b8228721eb13532dda5a6eb0c411bffe7879c88044b6701449f0"
    sha256 cellar: :any,                 ventura:        "24a0b39bf9dd8184685f458d4a154adf5b2b76d93bb221189e500fdb1e5a649d"
    sha256 cellar: :any,                 monterey:       "9bf5558c2ba41bdaa832660ad01c009e8691892cf61140b5a554e8ee8333de22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "174f3e9cc9c2bc69f9c6be9a7e0a1346f2f59955bedfbe2c6279de467f0b472c"
  end

  # Has been EOL since 2022-09-20
  deprecate! date: "2024-02-22", because: :unsupported

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "icu4c"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "6"
    cause "Only GCC 7.1 or newer is supported"
  end

  def install
    # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
    if DevelopmentTools.clang_build_version >= 1500
      inreplace "build/moz.configure/toolchain.configure", '"-Wl,--version"', '"-Wl,-ld_classic,--version"'
    end

    # Avoid installing into HOMEBREW_PREFIX.
    # https://github.com/Homebrew/homebrew-core/pull/98809
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Remove the broken *(for anyone but FF) install_name
    # _LOADER_PATH := @executable_path
    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""

    cd "js/src"
    system "autoconf213"
    mkdir "brew-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--enable-optimize",
                             "--enable-readline",
                             "--enable-release",
                             "--enable-shared-js",
                             "--disable-bootstrap",
                             "--disable-debug",
                             "--disable-jemalloc",
                             "--with-intl-api",
                             "--with-system-icu",
                             "--with-system-nspr",
                             "--with-system-zlib"
      system "make"
      system "make", "install"
    end

    (lib/"libjs_static.ajs").unlink

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin/"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              Formula["nspr"].opt_prefix
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end
