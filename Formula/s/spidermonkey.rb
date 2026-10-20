class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/153.5.1esr/source/firefox-153.5.1esr.source.tar.xz"
  version "153.5.1"
  sha256 "c6888848f90e7ebeacad38725b9bbbfe7c9bea7078098d47a2cf2c1ff3e18b83"
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
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "7"
    cause "Only GCC 8.1 or newer is supported"
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
      args = %w[
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-rust-simd
        --enable-shared-js
        --disable-bootstrap
        --disable-jemalloc
        --with-intl-api
        --with-system-icu
        --with-system-nspr
        --with-system-zlib
      ]

      system "../js/src/configure", *args, *std_configure_args
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
