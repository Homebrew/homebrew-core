class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/153.7.0esr/source/firefox-153.7.0esr.source.tar.xz"
  version "153.7.0"
  sha256 "7f8715ee7de2cf36a156216a9b1c7f26d1653010e65793bb2fce66e12edb6ea0"
  license "MPL-2.0"
  compatibility_version 1
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f25f17c9058ec8cd3c9b5812fce83b5dafa15bf31ddcf3510e89b512252b103"
    sha256 cellar: :any, arm64_tahoe:       "eae49eaa19b71ef010bfe152eb0dff5cc9c4f785cef6bc6d1d6c3c22c725051d"
    sha256 cellar: :any, arm64_sequoia:     "5881128688aa98f0744f44f84551debb7f3ad9d196c5e99ae1239aac2d9cddb7"
    sha256               arm64_linux:       "bc96ca5f4c161ed9f828960c20e7f92272e37bfb27a96b7566153ee46c50c10c"
    sha256               x86_64_linux:      "a80d768a8a26deb245be778d86bdc4de9925fbd43833cdd380e5e0ec61ea9c90"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "icu4c@79"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build

  on_macos do
    # Use LLD to work around lack of support for modern Apple ld
    # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1844694
    depends_on "lld" => :build if DevelopmentTools.clang_build_version >= 1500
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "7"
    cause "Only GCC 8.1 or newer is supported"
  end

  # Apply patch used by `gjs` to bypass build error.
  # ERROR: *** The pkg-config script could not be found. Make sure it is
  # *** in your path, or set the PKG_CONFIG environment variable
  # *** to the full path to pkg-config.
  # Ref: https://discourse.gnome.org/t/gnome-45-to-depend-on-spidermonkey-115/16653
  patch do
    on_macos do
      url "https://github.com/ptomato/mozjs/commit/c82346c4e19a73ed4c7f65a6b274fc2138815ae9.patch?full_index=1"
      sha256 "0f1cd5f80b4ae46e614efa74a409133e8a69fff38220314f881383ba0adb0f87"
      type :unofficial
      resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1783570"
    end
  end

  # Apply patch used by `gjs` to work around https://bugzilla.mozilla.org/show_bug.cgi?id=1973994
  patch do
    url "https://github.com/ptomato/mozjs/commit/9aa8b4b051dd539e0fbd5e08040870b3c712a846.patch?full_index=1"
    sha256 "5c2a8c804322ccacbc37f152a4a3d48a5fc2becffb1720a41e32c03899af0be6"
    type :unofficial
    resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1973994"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.O3 if DevelopmentTools.clang_build_version >= 1500 # lld doesn't support -Os

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(/^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:/, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(/^(\s*def mac_sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$/, "\\1\"#{MacOS.version}\"")
      end
    end

    # https://firefox-source-docs.mozilla.org/js/build.html
    ENV["MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE"] = "none"
    ENV["MOZCONFIG"] = mozconfig = buildpath/"mozconfig"
    mozconfig.write <<~EOS
      # Build the JS shell and shared library
      ac_add_options --enable-project=js
      ac_add_options --enable-shared-js
      ac_add_options --prefix=#{prefix}

      # Features, optimisations, etc.
      ac_add_options --disable-bootstrap
      ac_add_options --disable-debug
      ac_add_options --disable-jemalloc
      ac_add_options --enable-hardening
      ac_add_options --enable-optimize
      ac_add_options --enable-readline
      ac_add_options --enable-release
      ac_add_options --enable-rust-simd
      ac_add_options --with-intl-api
      ac_add_options --with-system-icu
      ac_add_options --with-system-nspr
      ac_add_options --with-system-zlib
    EOS

    system "./mach", "build"
    system "./mach", "install"

    rm(lib/"libjs_static.ajs")

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    bin.install_symlink "js#{version.major}" => "js"

    # Avoid writing nspr's versioned Cellar path in js*-config
    nspr_prefix = formula_opt_prefix("nspr")
    inreplace bin/"js#{version.major}-config", nspr_prefix.realpath, nspr_prefix
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
