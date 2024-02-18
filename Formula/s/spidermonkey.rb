class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.7.0esr/source/firefox-115.7.0esr.source.tar.xz"
  version "115.7.0"
  sha256 "13edffcd3ce9ff485eafe84ad256794a8ca3ca91fe06e5ed4df8e008c157a429"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "287f6ee206c5a23515b4c3a2d393e6acf85816673a93c58eeada1079c5363525"
    sha256 cellar: :any, arm64_ventura: "0ce4899a2662e5b76d38502667e8f7f778d42ca4bde736852172bf5dcfc93af6"
    sha256 cellar: :any, sonoma:        "367e435b7aadea89296879a449f9845c612ddaa0ea13c2981a98221f8b85edb9"
    sha256 cellar: :any, ventura:       "1cb280dd261720ab2031e8a008cb7e91c52a242d6b63fad7741b0ac04d9e8cf7"
    sha256               x86_64_linux:  "b3690f0f8f0b3da796b7337cf37c06e5a5a1cefc5beda30fc69dc4be00b7dbaf"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build # https://bugzilla.mozilla.org/show_bug.cgi?id=1857515
  depends_on "rust" => :build
  depends_on macos: :ventura # minimum SDK version 13.3
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "icu4c"
    depends_on "nspr"
  end

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
      url "https://github.com/ptomato/mozjs/commit/9f778cec201f87fd68dc98380ac1097b2ff371e4.patch?full_index=1"
      sha256 "a772f39e5370d263fd7e182effb1b2b990cae8c63783f5a6673f16737ff91573"
    end
  end

  def install
    # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
    if DevelopmentTools.clang_build_version >= 1500
      inreplace "build/moz.configure/toolchain.configure", '"-Wl,--version"', '"-Wl,-ld_classic,--version"'
    end

    mkdir "brew-build" do
      args = %W[
        --prefix=#{prefix}
        --enable-optimize
        --enable-readline
        --enable-release
        --enable-shared-js
        --disable-bootstrap
        --disable-debug
        --disable-jemalloc
        --with-intl-api
        --with-system-zlib
      ]
      if OS.mac?
        # Force build script to use Xcode install_name_tool
        ENV["INSTALL_NAME_TOOL"] = DevelopmentTools.locate("install_name_tool")
      else
        # System libraries are only supported on Linux and build fails if args are used on macOS.
        # Ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1776255
        args += %w[--with-system-icu --with-system-nspr]
      end

      system "../js/src/configure", *args
      system "make"
      system "make", "install"
    end

    (lib/"libjs_static.ajs").unlink

    # Add an unversioned `js` to be used by dependents like `jsawk` & `plowshare`
    ln_s bin/"js#{version.major}", bin/"js"
    return unless OS.linux?

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
