class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.20.0esr/source/firefox-115.20.0esr.source.tar.xz"
  version "115.20.0"
  sha256 "bd893c7ce04e23aa17c48ebcbbb43c0911e03fbc5fb8660e9085d798d6a1c8b1"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?/v?(115(?:\.\d+)+)/releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "93862e971a36ada2d0b2f19a5e8e8930ae76d8b706e8d59306ee6b09ba35e600"
    sha256 cellar: :any, arm64_sonoma:  "f42dbdfc5fd6006f6cc3d8f79dd2304d8d2efa478c4322a6f7939f9a51beecd2"
    sha256 cellar: :any, arm64_ventura: "cdc0bc072238f7b0bce54bfcc4f714008f453894cc063f036544e66ecf2eafca"
    sha256 cellar: :any, sonoma:        "e019b17bdbcedb22b6acf650a8bc4bb71f1b9effd5e3ee1abb9e8ab488441a67"
    sha256 cellar: :any, ventura:       "770140c7f5ce13b94007293e7a1031aee3e249e2bf093d24d957ea8e04f481b7"
    sha256               x86_64_linux:  "146147959a5f20a13cc719dd9996c52897b2970b0f556d568055184e2b254251"
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
