class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/115.9.0esr/source/firefox-115.9.0esr.source.tar.xz"
  version "115.9.0"
  sha256 "db3b3371c5e6636de73798635531df137b17c5b78bdee03810930b29e8212803"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central", using: :hg

  # Spidermonkey versions use the same versions as Firefox, so we simply check
  # Firefox ESR release versions.
  livecheck do
    url "https://www.mozilla.org/en-US/firefox/releases/"
    regex(/data-esr-versions=["']?v?(\d+(?:\.\d+)+)["' >]/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "c8a244aed5005fa0de34956d781a96ceba4666df9fb9b15ef8d7d0344c57e4a9"
    sha256 cellar: :any, arm64_ventura: "fe448b4c9b91e39fd449dcb9e607e86331577edf8cda7abe6cd3f9c182a6940f"
    sha256 cellar: :any, sonoma:        "815b1ababfec575ffcfd41f571fedcb7e07d844a286008eb80a22a0747892a91"
    sha256 cellar: :any, ventura:       "ea19b4c1de0345eaa053cf6fc04c6f2028106b8f1a840dd80c110987455fd962"
    sha256               x86_64_linux:  "34dffb49fdd294539a7e2f50575bbac59d48951c54bc2d8003d634e5b09886cd"
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
