class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/102.14.0esr/source/firefox-102.14.0esr.source.tar.xz"
  version "102.14.0"
  sha256 "1ab85081c08a472cfd869873dba0e76ae6d9e83c1b8f23741e4c9d5471a5efee"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29a1f7b672b200702a8099e354447a64cdd9a6898c7705e24c366a7a0288e5d3"
    sha256 cellar: :any,                 arm64_monterey: "0b8aa6694a714be0056dbfa2bd89ff986d54f00d85c399236404672ac3721895"
    sha256 cellar: :any,                 arm64_big_sur:  "d861fe8fda486a803a6a9a053b3b68a8d9f0eb0a3e289799a63cb75435e9dc71"
    sha256 cellar: :any,                 ventura:        "a96e9c8f66db222c7c1edc0cc547fbb23ceea26fa2ceb9946102d122f3ff98aa"
    sha256 cellar: :any,                 monterey:       "c84fd9a36d06dd5c6c995d72d7e874f514d99790257f4b8e404368d13416c04a"
    sha256 cellar: :any,                 big_sur:        "fc49a115c213765bdec4a17ba700bbf8ad34d64b97d148a10466e6940545c4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d792e70d4ff39c9e4f09d4629ffe6f5952e94ec2b09e296af0ad03c0fcfcf12"
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
