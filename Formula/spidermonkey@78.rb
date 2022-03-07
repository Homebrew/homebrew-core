class SpidermonkeyAT78 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/78.15.0esr/source/firefox-78.15.0esr.source.tar.xz"
  version "78.15.0"
  sha256 "a4438d84d95171a6d4fea9c9f02c2edbf0475a9c614d968ebe2eedc25a672151"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 monterey:     "0c2c93d407197f7cdb8606682cd3c0b3e6216a5f7b9ea300c697aac9564481e2"
    sha256 cellar: :any,                 big_sur:      "caa0c1a936d04a4dc31106dfd6b483fe9b245abebcf1f18c56adec7210b384f2"
    sha256 cellar: :any,                 catalina:     "3f417ef0808366725734977fcaae80010c5cbe29b3954fd178056cb2dc952fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4b9188b778310a6365e4b879cc94b593ab6b3eb4fc879eed813f9001eb252ec2"
  end

  depends_on "autoconf@2.13" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on arch: :x86_64 # ld: unknown/unsupported architecture name for: -arch armv4t
  depends_on "icu4c"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  # From python/mozbuild/mozbuild/test/configure/test_toolchain_configure.py
  fails_with :gcc do
    version "6"
    cause "Only GCC 7.1 or newer is supported"
  end

  def install
    inreplace "build/moz.configure/toolchain.configure",
              "sdk_max_version = Version('10.15.4')",
              "sdk_max_version = Version('99.99')"

    # Remove the broken *(for anyone but FF) install_name
    # _LOADER_PATH := @executable_path
    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""

    mkdir "brew-build" do
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-optimize",
                                    "--enable-readline",
                                    "--enable-release",
                                    "--enable-shared-js",
                                    "--disable-jemalloc",
                                    "--with-intl-api",
                                    "--with-system-icu",
                                    "--with-system-nspr",
                                    "--with-system-zlib"
      system "make"
      system "make", "install"
    end

    (lib/"libjs_static.ajs").unlink

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
