class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/91.12.0esr/source/firefox-91.12.0esr.source.tar.xz"
  version "91.12.0"
  sha256 "6c0b8ff1826885eeace19ec87ae9e5a6512284d4863930713c8a288a03832b5c"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "640164a045d6aec276bca42157a1cc236692ceda4678644260699a7bc9423385"
    sha256 cellar: :any,                 arm64_big_sur:  "ef073dbbfd5f688bddd0d8c0e3c018003fc915f3856c9a07cdc62bf1ddbab8bd"
    sha256 cellar: :any,                 monterey:       "73ed89ed3f7eb7b6bc8f3321d3e79e2b7a79338dbdf2f6bfcd6e3ba1e47d489a"
    sha256 cellar: :any,                 big_sur:        "88960b7ca336a62efa51d3049bbd6404f8d212d4fb8fc1203dfbd73c4cc766f1"
    sha256 cellar: :any,                 catalina:       "ecd70bb4c127202a640ca517bd0ff06cd6a5955d40f430ee906c2f445d1ca966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9006c14cc5102cafc76576f16fad2bcfe3ce769ac775bf1065815cf5d9aa3c"
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
