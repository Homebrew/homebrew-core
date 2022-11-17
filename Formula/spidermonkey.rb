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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "96df36bb38c645f3dd44371fc43de60617c793e8e675517b305f294131ec6158"
    sha256 cellar: :any,                 arm64_monterey: "d8760503883beda2a22b28075fe3dd1de5acafcd1acc50554df80339e1ca5c63"
    sha256 cellar: :any,                 arm64_big_sur:  "0721a494f718ab24661fe956f7da3a2f6603ddd6c67af6b17c4e2fa1cf8ba4f8"
    sha256 cellar: :any,                 ventura:        "b1b6faa555b3c610f7089c70d0cb7812ebda0c3db485bfb7da21087e0cd79bdd"
    sha256 cellar: :any,                 monterey:       "7d33cefdfa788ba420229c49699e517b0016b9ee8ef50c15af9c65e9f9369bcd"
    sha256 cellar: :any,                 big_sur:        "2438c36d8a413953233352bd5c12a37e89c1bd73cacf5567d5bf073b7bb58e9c"
    sha256 cellar: :any,                 catalina:       "e74c14c4b9816b51d03bf89d635135c78c338ef60157c9955ef813458f0477aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc058f5e0db07c35247951509d61f6a562e3ad29579c9d6b5b1ed7cd80592f79"
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
