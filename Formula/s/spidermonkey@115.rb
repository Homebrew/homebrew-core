class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.21.0esr/source/firefox-115.21.0esr.source.tar.xz"
  version "115.21.0"
  sha256 "ff118b1d6d17cefe8eef08bba74ae0d47939010d21afdbaadd8859fd4016b674"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?/v?(115(?:\.\d+)+)/releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "79c292c235d28ccca95422e38e8a3bb11ed17679317181238cffa071c50868bb"
    sha256 cellar: :any, arm64_sonoma:  "84811a850e6e15e66ed67ae1320fe4e15245eba812db65c271c73528388f902c"
    sha256 cellar: :any, arm64_ventura: "97a40a74ef64335ebe21243b7ab85a8ba854744e392537295fa33cfc21ef51f8"
    sha256 cellar: :any, sonoma:        "17d17df8dfd81ff1770fc07dfa26d7fedc0a18f65fc796c6034c1d6e7fa9fe36"
    sha256 cellar: :any, ventura:       "96e59d8369db111c6a8b23246db3ee300c04ceb60725aa312cab0c6b3008d708"
    sha256               x86_64_linux:  "7728fbaf5bf6f373925398791504801841204a496ac84e1b7addbc0cd004bfc4"
  end

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "python@3.11" => :build # https://bugzilla.mozilla.org/show_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on "icu4c@76"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "7"
    cause "Only GCC 8.1 or newer is supported"
  end

  # Apply patch used by `gjs` to bypass build error.
  # ERROR: *** The pkg-config script could not be found. Make sure it is
  # *** in your path, or set the PKG_CONFIG environment variable
  # *** to the full path to pkg-config.
  # Ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1783570
  # Ref: https://discourse.gnome.org/t/gnome-45-to-depend-on-spidermonkey-115/16653
  patch do
    on_macos do
      url "https://github.com/ptomato/mozjs/commit/9f778cec201f87fd68dc98380ac1097b2ff371e4.patch?full_index=1"
      sha256 "a772f39e5370d263fd7e182effb1b2b990cae8c63783f5a6673f16737ff91573"
    end
  end

  def install
    # Workaround for ICU 76+
    # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1927380
    inreplace "js/moz.configure", '"icu-i18n >= 73.1"', '"icu-i18n >= 73.1 icu-uc"'

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,--version"' if DevelopmentTools.clang_build_version >= 1500
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(/^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:/, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(/^(\s*def sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$/, "\\1\"#{MacOS.version}\"")
      end

      # Force build script to use Xcode install_name_tool
      ENV["INSTALL_NAME_TOOL"] = DevelopmentTools.locate("install_name_tool")
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-shared-js
        --disable-bootstrap
        --disable-debug
        --disable-jemalloc
        --with-intl-api
        --with-system-icu
        --with-system-nspr
        --with-system-zlib
      ]

      system "../js/src/configure", *args
      system "make"
      system "make", "install"
    end

    rm(lib/"libjs_static.ajs")

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
