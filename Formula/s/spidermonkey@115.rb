class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.19.0esr/source/firefox-115.19.0esr.source.tar.xz"
  version "115.19.0"
  sha256 "7e64a398e84208ac494d3311f849971723c3fe3c516f854c2c8fecd04968bed6"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?/v?(115(?:\.\d+)+)/releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b06ac3d121c585800cb945f04246b6a79d03dfd893dd21680890b1816457a26b"
    sha256 cellar: :any, arm64_sonoma:  "06da600c4c59dbcfb28fc5d898ffc9f33f58f17f7bd4ef7ff5d9fb3ed7f43f2c"
    sha256 cellar: :any, arm64_ventura: "2bf94215861dcff4b8b344160b7f4d65e539abb860792a0bb79d1d14fcc95505"
    sha256 cellar: :any, sonoma:        "03a759b95a4f08174ff02e67d7ac171ac02930476094664a71946d9b8524b7a1"
    sha256 cellar: :any, ventura:       "8ad4a610f30169c5cbc9ab7c40a8044b671c9fd4d200f3bff31df0587a15e68d"
    sha256               x86_64_linux:  "ef11b6813a61d0fe72a3360eb5137970a1c9da6b4ab0cff278c71939e3805285"
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
