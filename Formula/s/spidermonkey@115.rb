class SpidermonkeyAT115 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.24.0esr/source/firefox-115.24.0esr.source.tar.xz"
  version "115.24.0"
  sha256 "81b95a58160afbae72b45c58f818c6ce992f53547e5ea78efbb2c59e864e4200"
  license "MPL-2.0"

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(%r{href=.*?/v?(115(?:\.\d+)+)/releasenotes}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "238c04ed2a99a38f7dde51657f76753a8a1d40758e3e5e524c42303864209cd8"
    sha256 cellar: :any, arm64_sonoma:  "581420592aa67ce63b02579d99f81130399d086db22b2fcfbee8e6a99c3e4c3a"
    sha256 cellar: :any, arm64_ventura: "73cb87c91e9d059a71218c36ffd194a99fb2a512990a681ffef45dfc406a3c4e"
    sha256 cellar: :any, sonoma:        "5eb778c67f6b734bc05be0c503ad021c50ed0bead89f730a533db7d7cf9e9386"
    sha256 cellar: :any, ventura:       "5c89548fbbb33f39c2359aacc83f828ccc0189fc3ca7b567068bf3c9a826ed75"
    sha256               arm64_linux:   "9c13d740d2344c2bc8dfaef636d59f74012cf0dc94b48f177fcb9472bfff0fd3"
    sha256               x86_64_linux:  "cd710f663cfcf8b8c834d5b856db4b56e799145ba9e9138d3ffebe9f7bda5332"
  end

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "python@3.11" => :build # https://bugzilla.mozilla.org/show_bug.cgi?id=1857515
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
      url "https://github.com/ptomato/mozjs/commit/9f778cec201f87fd68dc98380ac1097b2ff371e4.patch?full_index=1"
      sha256 "a772f39e5370d263fd7e182effb1b2b990cae8c63783f5a6673f16737ff91573"
    end
  end

  # 1. Fix to find linker on macos-15, abusing LD_PRINT_OPTIONS is not working
  # 2. Fix to error: reference to non-static member function must be called
  # Issue ref: https://hg-edge.mozilla.org/integration/autoland/rev/223087fdc29f
  patch :DATA

  def install
    # Workaround for ICU 76+
    # Issue ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1927380
    inreplace "js/moz.configure", '"icu-i18n >= 73.1"', '"icu-i18n >= 73.1 icu-uc"'

    if OS.mac?
      inreplace "build/moz.configure/toolchain.configure" do |s|
        # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
        s.sub! '"-Wl,--version"', '"-Wl,-ld_classic,--version"' if DevelopmentTools.clang_build_version >= 1500
        # Allow using brew libraries on macOS (not officially supported)
        s.sub!(/^(\s*def no_system_lib_in_sysroot\(.*\n\s*if )bootstrapped and value:/, "\\1False:")
        # Work around upstream only allowing build on limited macOS SDK (14.4 as of Spidermonkey 128)
        s.sub!(/^(\s*def sdk_min_version\(.*\n\s*return )"\d+(\.\d+)*"$/, "\\1\"#{MacOS.version}\"")
      end

      # Force build script to use Xcode install_name_tool
      ENV["INSTALL_NAME_TOOL"] = DevelopmentTools.locate("install_name_tool")
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-hardening
        --enable-optimize
        --enable-readline
        --enable-release
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
      system "make"
      system "make", "install"
    end

    rm(lib/"libjs_static.ajs")

    # Avoid writing nspr's versioned Cellar path in js*-config
    inreplace bin/"js#{version.major}-config",
              Formula["nspr"].prefix.realpath,
              Formula["nspr"].opt_prefix
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js#{version.major} #{path}").strip
  end
end

__END__
diff --git a/build/moz.configure/toolchain.configure b/build/moz.configure/toolchain.configure
index 3f91d71..0133a67 100644
--- a/build/moz.configure/toolchain.configure
+++ b/build/moz.configure/toolchain.configure
@@ -1783,7 +1783,16 @@ def select_linker_tmpl(host_or_target):
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
diff --git a/js/src/threading/ExclusiveData.h b/js/src/threading/ExclusiveData.h
index 38e89f10a..2d8ca831b 100644
--- a/js/src/threading/ExclusiveData.h
+++ b/js/src/threading/ExclusiveData.h
@@ -109,11 +109,6 @@ class ExclusiveData {
  explicit ExclusiveData(const MutexId& id, Args&&... args)
      : lock_(id), value_(std::forward<Args>(args)...) {}

-  ExclusiveData(ExclusiveData&& rhs)
-      : lock_(std::move(rhs.lock)), value_(std::move(rhs.value_)) {
-    MOZ_ASSERT(&rhs != this, "self-move disallowed!");
-  }
-
  ExclusiveData& operator=(ExclusiveData&& rhs) {
    this->~ExclusiveData();
    new (mozilla::KnownNotNull, this) ExclusiveData(std::move(rhs));
