class SpidermonkeyAT140 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/140.17.0esr/source/firefox-140.17.0esr.source.tar.xz"
  version "140.17.0"
  sha256 "4d6ed3b18b2069c55bab12d8ba95da6013ac0b036d8a031df8b9f39a25d05c33"
  license "MPL-2.0"
  compatibility_version 1

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?/v?(140(?:\.\d+)+)/releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bdd545ed24b1d5a0e6decb92ee0f1fb8a697d8668e9fb2c0f3e7ba6ca29f9dad"
    sha256 cellar: :any, arm64_tahoe:       "f58e587b4c9c5366f0ff26267ea2598c5717a7120eee795b36ba7940f926a846"
    sha256 cellar: :any, arm64_sequoia:     "962ad454f64c87be0834f8ffc9c6cf453aa47c84bdf748bbbb605b9d1dc27c6a"
    sha256               arm64_linux:       "ccd1c3a2854a01195cdca63e94c9828f024b5bb01e02cf3f5084a901cf9c0279"
    sha256               x86_64_linux:      "045e0e43c4fc81546b4e266c87551b9b406dcf10519ff2987c5ef83ac1f27df4"
  end

  keg_only :versioned_formula

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

  # Backport support for Python 3.14
  patch do
    url "https://github.com/mozilla-firefox/firefox/commit/d497aa4f770ca02f6083e93b94996a8fe32c2ff4.patch?full_index=1"
    sha256 "026f91a56cd60907a87c62dd4143eac8300d6fc7433b94888229c632a43c34bf"
    type :backport
    resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1969769"
  end

  # Fix Rust target detection for OpenEmbedded Linux.
  # TODO: Check resolution in https://bugzilla.mozilla.org/show_bug.cgi?id=2068494
  # Fixes:
  # checking for rust host triplet...
  # ERROR: Don't know how to translate x86_64-pc-linux-gnu for rustc
  patch :DATA

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

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin/"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              formula_opt_prefix("nspr")
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end

__END__
diff --git a/build/moz.configure/rust.configure b/build/moz.configure/rust.configure
--- a/build/moz.configure/rust.configure
+++ b/build/moz.configure/rust.configure
@@ -410,7 +410,14 @@ def detect_rustc_target(
             return narrowed[0].rust_target

-        # Finally, see if the vendor can be used to disambiguate.
-        narrowed = [c for c in candidates if c.target.vendor == host_or_target.vendor]
+        # Finally, see if the vendor can be used to disambiguate. Autoconf uses
+        # "pc" where Rust uses "unknown" for generic targets.
+        vendor_aliases = {"unknown": ("pc",)}
+        narrowed = [
+            c
+            for c in candidates
+            if c.target.vendor == host_or_target.vendor
+            or host_or_target.vendor in vendor_aliases.get(c.target.vendor, ())
+        ]
         if len(narrowed) == 1:
             return narrowed[0].rust_target

diff --git a/python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py b/python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
--- a/python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
+++ b/python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
@@ -1881,6 +1881,7 @@ def gen_invoke_rustc(version, rustup_wrapper=False):
                 "x86_64-fortanix-unknown-sgx",
                 "x86_64-fuchsia",
                 "x86_64-linux-android",
+                "x86_64-oe-linux-gnu",
                 "x86_64-pc-nto-qnx710",
                 "x86_64-pc-solaris",
                 "x86_64-pc-windows-gnu",
