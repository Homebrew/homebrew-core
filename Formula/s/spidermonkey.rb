class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/153.5.0esr/source/firefox-153.5.0esr.source.tar.xz"
  version "153.5.0"
  sha256 "28714a7d4f9b38c7aafbe38022de7775a3d9cb3c1ebf19a567c26eb761e3410b"
  license "MPL-2.0"
  compatibility_version 2
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc46d71f60f529928d13aac4bff8a1bef68e00873937b226fabe64a26fe57512"
    sha256 cellar: :any, arm64_tahoe:       "d8ba23d2d0a11d20fea69bc99f001cda910c75dc58f476266ceab19af1aaed85"
    sha256 cellar: :any, arm64_sequoia:     "3c41d10ee0e84c34fb59f5563e69bb8ce51000cb75d286dd5096f33d9ea1cca8"
    sha256               arm64_linux:       "288699c66c00ea7d4e2e43d2cd0248ab1cb8ac5e482e81659780a8e7358eb119"
    sha256               x86_64_linux:      "a013d8b2c399eb57b192d9c2327bc1e5bf09594c05a0497082bf805532821c12"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
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
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :clang do
    build 1699
    cause "Only clang/llvm 19.0 or newer is supported"
  end

  fails_with :gcc do
    version "9"
    cause "Only GCC 10.1 or newer is supported"
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

  deny_network_access!

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
