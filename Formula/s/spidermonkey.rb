class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/140.5.0esr/source/firefox-140.5.0esr.source.tar.xz"
  version "140.5.0"
  sha256 "832b7ef3e5f7a2430e0ba0b9000dab6fdd8f65bccff8bcf7eeb9ed16e6d310e2"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "17e51ea8f95f8b53dee6726bc04b2a0e119afec5e5199d1289e773afbc774555"
    sha256 cellar: :any, arm64_sequoia: "425ef161fc8e74574b2db72a4cb7b0cdf6dc40ce4ee9581d8a52d3b58c49de4d"
    sha256 cellar: :any, arm64_sonoma:  "c1dd5349fc979db3afb98818e72d733c7e806cfea5d5e96399324fb50b07dc1e"
    sha256 cellar: :any, sonoma:        "bc2080fd498d7be55ee7cef408810891636bb4ff7252758a1a7c0f05a77250e8"
    sha256               arm64_linux:   "f5a17ed759310d39379395bc94a352b4dadb7cf9920104062383cdd229ccba5a"
    sha256               x86_64_linux:  "8da85566d8823f2e9e84a1727a5f87ca4ebcd769daef9f8f00dd048f96c103e6"
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
