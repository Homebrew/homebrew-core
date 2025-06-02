class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/128.11.0esr/source/firefox-128.11.0esr.source.tar.xz"
  version "128.11.0"
  sha256 "f2ed90374a670fe5eccfd5bf36d2e311affd955d1f3507861c738b9aa7a1ffec"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://download.mozilla.org/?product=firefox-esr-latest-ssl"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "5fdcb42d55d4cb10207fe7974ef9ef4377bbf4802005657edc9592070dbf1eda"
    sha256 cellar: :any, arm64_sonoma:  "89d7665c6447840eca941b35ead5dce2b0adc28212ff43a9759da86ae8ef383f"
    sha256 cellar: :any, arm64_ventura: "0c9aef5f5bf4e5d0c1e4e25a58f1be0b1c6783130cad369694a93f8b64cab4af"
    sha256 cellar: :any, sonoma:        "e747dcda8088f37eb4fccd4e5e8c50af00fed112fa20861381519f84455b05f5"
    sha256 cellar: :any, ventura:       "2fbeb982a3363d4fa3b490a1439b0bdc075f3b454062d3827f2a495f30872450"
    sha256               arm64_linux:   "583a2e47642d889caf22e576e671e8773d37c959e5e51072049996ff4de1cd37"
    sha256               x86_64_linux:  "671e900b493463f65929e487b900cba2461c715db70b65264afc01c1a8f31ffd"
  end

  depends_on "cbindgen" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "icu4c@77"
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

  # Fix to find linker on macos-15, abusing LD_PRINT_OPTIONS is not working
  # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1964280
  patch :DATA

  def install
    # Workaround for ICU 76+
    # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1927380
    inreplace "js/moz.configure", '"icu-i18n >= 73.1"', '"icu-i18n >= 73.1 icu-uc"'

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

__END__
diff --git a/build/moz.configure/toolchain.configure b/build/moz.configure/toolchain.configure
index 264027e..2e073a3 100644
--- a/build/moz.configure/toolchain.configure
+++ b/build/moz.configure/toolchain.configure
@@ -1906,7 +1906,16 @@ def select_linker_tmpl(host_or_target):
                 kind = "ld64"
 
             elif retcode != 0:
-                return None
+                # macOS 15 fallback: try `-Wl,-v` if --version failed
+                if target.kernel == "Darwin":
+                    fallback_cmd = cmd_base + linker_flag + ["-Wl,-v"]
+                    retcode2, stdout2, stderr2 = get_cmd_output(*fallback_cmd, env=env)
+                    if retcode2 == 0 and "@(#)PROGRAM:ld" in stderr2:
+                        kind = "ld64"
+                    else:
+                        return None
+                else:
+                    return None
 
             elif "mold" in stdout:
                 kind = "mold"
