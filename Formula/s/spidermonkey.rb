class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/140.7.1esr/source/firefox-140.7.1esr.source.tar.xz"
  version "140.7.1"
  sha256 "e42d26aeabd17ab1e642656c7b1bc8cadf705ce2ac6751b103dd407f5af32827"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7a48b96f3e68cdd1fcd3aaf07735ac10e05cc294e3b6044ed60852d3d9b4efaf"
    sha256 cellar: :any, arm64_sequoia: "e85b5943cd77e8022df2b251b10ed65081cc75e3f78037930cfe88e66fd9e479"
    sha256 cellar: :any, arm64_sonoma:  "5e9f8e6c8f5cfbf8e1aa6578e59e6eb81f81811ac05bfc26f8794a54f99d2cd6"
    sha256 cellar: :any, sonoma:        "0467b4bbdc0afbf8cfd616df001147f9046815d185b2edd4df0c8d5674a443a7"
    sha256               arm64_linux:   "9f9762f5682a651f33ceeebf026c9063f0861cf55d53a8a5b261e689558e4b36"
    sha256               x86_64_linux:  "1034254f4968ba3a66bdb8bb4275efb5cc278b87f669b9d5faa9252e1a3a59ff"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "icu4c@78"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build

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
  # Ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1783570
  # Ref: https://discourse.gnome.org/t/gnome-45-to-depend-on-spidermonkey-115/16653
  patch do
    on_macos do
      url "https://github.com/ptomato/mozjs/commit/c82346c4e19a73ed4c7f65a6b274fc2138815ae9.patch?full_index=1"
      sha256 "0f1cd5f80b4ae46e614efa74a409133e8a69fff38220314f881383ba0adb0f87"
    end
  end

  # Apply patch used by `gjs` to work around https://bugzilla.mozilla.org/show_bug.cgi?id=1973994
  patch do
    url "https://github.com/ptomato/mozjs/commit/9aa8b4b051dd539e0fbd5e08040870b3c712a846.patch?full_index=1"
    sha256 "5c2a8c804322ccacbc37f152a4a3d48a5fc2becffb1720a41e32c03899af0be6"
  end

  # Backport support for Python 3.14
  patch do
    url "https://github.com/mozilla-firefox/firefox/commit/d497aa4f770ca02f6083e93b94996a8fe32c2ff4.patch?full_index=1"
    sha256 "026f91a56cd60907a87c62dd4143eac8300d6fc7433b94888229c632a43c34bf"
  end

  def install
    ENV.runtime_cpu_detection

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1844694
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,-v"' if DevelopmentTools.clang_build_version >= 1500
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(/^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:/, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(/^(\s*def mac_sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$/, "\\1\"#{MacOS.version}\"")
      end
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-rust-simd
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
      ENV.deparallelize { system "make" }
      system "make", "install"
    end

    rm(lib/"libjs_static.ajs")

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    bin.install_symlink "js#{version.major}" => "js"

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
