class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/140.17.0esr/source/firefox-140.17.0esr.source.tar.xz"
  version "140.17.0"
  sha256 "4d6ed3b18b2069c55bab12d8ba95da6013ac0b036d8a031df8b9f39a25d05c33"
  license "MPL-2.0"
  revision 1
  compatibility_version 1
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf8ee6210f82f51bf6030481200e290047c30c40f424e913f9ab94ad95e8461c"
    sha256 cellar: :any, arm64_tahoe:       "fe7c36820c44d3596bf6ccf0be1f780f10c7d45b2733cc19384c1c5027b4f750"
    sha256 cellar: :any, arm64_sequoia:     "300c9e96e7e7af78e900adcb7981ac103aac6567f38be89f744d0ec3c46c3d8b"
    sha256               arm64_linux:       "c93cbe80d436dbcabeb66911873cccc9e81dacb2b55aaa9a78c60c005ee1b7f9"
    sha256               x86_64_linux:      "e769c6bb279709ef91d701e89fc9625bf84491efa43bbe5992279f683ff3ac2f"
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

  # Backport support for Python 3.14
  patch do
    url "https://github.com/mozilla-firefox/firefox/commit/d497aa4f770ca02f6083e93b94996a8fe32c2ff4.patch?full_index=1"
    sha256 "026f91a56cd60907a87c62dd4143eac8300d6fc7433b94888229c632a43c34bf"
    type :backport
    resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1969769"
  end

  # Backport mach support for Python 3.15, which removed `ast.Constant.s`
  patch do
    url "https://github.com/mozilla-firefox/firefox/commit/e6db063cdccce8ace1fc7f7bc881175f9d10b255.patch?full_index=1"
    sha256 "57b07ee0982328bed30bb28de707b9679f943454edc54589eb4f98a4c8e6eaa7"
    type :backport
    resolves "https://bugzilla.mozilla.org/show_bug.cgi?id=1983713"
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
