class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/91.13.0esr/source/firefox-91.13.0esr.source.tar.xz"
  version "91.13.0"
  sha256 "53be2bcde0b5ee3ec106bd8ba06b8ae95e7d489c484e881dfbe5360e4c920762"
  license "MPL-2.0"
  revision 1
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e985b3fdf8827f7d491fde110937767a30fad8b33a4a92443a7be611c3c57359"
    sha256 cellar: :any,                 arm64_big_sur:  "f666e936df2a0114799bcf80b5324ffde8ba8efa525587c20af9c9e72ef14c4a"
    sha256 cellar: :any,                 monterey:       "491e3c9bfa16565f5c10d1d386240abb913f7ae51e7dd57063ec9b077ab166f5"
    sha256 cellar: :any,                 big_sur:        "28bf6ac69da070d01abf59c931eafe3c30d9a68517391e95a786166e06d49266"
    sha256 cellar: :any,                 catalina:       "bd17e93ceba743007e62a6213e385e67dfc6282c832fa6649c20247ad0e55c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c02fdd3307b92699021febf74e0ccf1a73dbcb124f31c88081aab57b0f312f"
  end

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

  conflicts_with "narwhal", because: "both install a js binary"

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "6"
    cause "Only GCC 7.1 or newer is supported"
  end

  def install
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
                             "--disable-jemalloc",
                             "--with-intl-api",
                             "--with-system-icu",
                             "--with-system-nspr",
                             "--with-system-zlib"
      system "make"
      system "make", "install"
    end

    (lib/"libjs_static.ajs").unlink

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    ln_s bin/"js#{version.major}", bin/"js"

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin/"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              Formula["nspr"].opt_prefix
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
