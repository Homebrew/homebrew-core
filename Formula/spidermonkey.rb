class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/91.7.1esr/source/firefox-91.7.1esr.source.tar.xz"
  version "91.7.1"
  sha256 "57494a445e72f7eacb0bb870a3a79cde3c2143e234873c0c3e269df1d4742c92"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ef3dceac6e95ce6c6d5ba4ee722e4e2446b4c64cf6f93dcc04214f8d306f3c6"
    sha256 cellar: :any,                 arm64_big_sur:  "f814a24615d7e1a81542029ec94ae9c34481aa4083fe0e4b8428fd49356db2b3"
    sha256 cellar: :any,                 monterey:       "035b631591d94fe442ad4dad23605feebccb64553794f2ac988277f1243995cd"
    sha256 cellar: :any,                 big_sur:        "b7654865d6e6fd94dbd46658fc32f193d78344236bacd8c3ea8b3ff375bffc91"
    sha256 cellar: :any,                 catalina:       "095c81ada49644ceed800e0941b259e4219dac49f22ee7cc46fb5807c8f204d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975a0aa4246b06d6c4b019b1fb5f0876ac431aa1267d2ab8e3712f501f0daa8e"
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

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "narwhal", because: "both install a js binary"

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "6"
    cause "Only GCC 7.1 or newer is supported"
  end

  def install
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
