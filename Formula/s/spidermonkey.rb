class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/140.13.0esr/source/firefox-140.13.0esr.source.tar.xz"
  version "140.13.0"
  sha256 "f53b9dc6942abda1185aa7d79048f59fc075020da36b4dd6b31f668b88714d01"
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
    sha256 cellar: :any, arm64_tahoe:   "7027603c9ec114598998a2f72f4df743ee00ce910978d28b24cbd8378e3ad209"
    sha256 cellar: :any, arm64_sequoia: "4b0128a46b0f5482950cf1b15b74c5cd88b2cc24aab16ac9abbceabda4e4e59c"
    sha256 cellar: :any, arm64_sonoma:  "147ecb18fffd0e11f70b0a6e8a7593940a7992b73d1e624248a38341b5b68717"
    sha256 cellar: :any, sonoma:        "7299b293de9556ae20ef83ff4a80672cd34b207b501d4c856f63dc68785e13e4"
    sha256               arm64_linux:   "1e6c7aa0b1202e05c3c203ca5ebd6950fc52fb02b77499046150e2b80634ff77"
    sha256               x86_64_linux:  "25b0032885046a3fe77926a1b37d21b01be823dae80dad482327b01e05cd2b40"
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

  # Backport support for Python 3.14
  patch do
    url "https://github.com/mozilla-firefox/firefox/commit/d497aa4f770ca02f6083e93b94996a8fe32c2ff4.patch?full_index=1"
    sha256 "026f91a56cd60907a87c62dd4143eac8300d6fc7433b94888229c632a43c34bf"
    type :backport
    resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1969769"
  end

  def install
    ENV.runtime_cpu_detection
    ENV.O3 if DevelopmentTools.clang_build_version >= 1500 # lld doesn't support -Os

    # Vendored encoding_rs 0.8.35 fails to build with rust 1.95 (Mask::select moved
    # to a trait method). Use cargo's `[patch.crates-io]` to redirect to the upstream
    # commit that fixes it (https://github.com/hsivonen/encoding_rs/pull/130).
    File.open(".cargo/config.toml.in", "a") do |f|
      f.puts <<~TOML

        [patch.crates-io]
        encoding_rs = { git = "https://github.com/hsivonen/encoding_rs", rev = "dc06d71cb14390433bcd5a78975cbe7a29e47333" }
      TOML
    end

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
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
              formula_opt_prefix("nspr")
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
