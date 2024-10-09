class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/128.2.0esr/source/firefox-128.2.0esr.source.tar.xz"
  version "128.2.0"
  sha256 "9617a1e547d373fe25c2f5477ba1b2fc482b642dc54adf28d815fc36ed72d0c2"
  license "MPL-2.0"
  revision 2
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/organizations/notes/"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6fe0796eee858a564e69b1177dd570c2a44960d5fc6df5825d34f0ae5104e3ee"
    sha256 cellar: :any, arm64_sonoma:  "11974635b9e35ccd0edf36f553732fc91e7a8b968603e9be54a09b2a13a21f99"
    sha256 cellar: :any, arm64_ventura: "b41e468afe95410db6fa3dcec3b506567bd360214870b54b18243f83c8e4e5c8"
    sha256 cellar: :any, sonoma:        "27799a651b2291ef1b6e15f5c09438c7383616852fa0020edcd0023f92732218"
    sha256 cellar: :any, ventura:       "2c9b914fd1c12313bc3a1eb5af3788ffd35983e9e7b40f1f7cffbb17d3bf8caf"
    sha256               x86_64_linux:  "a14155cd533018b60d756bf03f5123450683befe381854d92d18db20c9fcc812"
  end

  depends_on "cbindgen" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build
  depends_on "icu4c@76"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  conflicts_with "narwhal", because: "both install a js binary"

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

  def install
    ENV.runtime_cpu_detection

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,--version"' if DevelopmentTools.clang_build_version >= 1500
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
