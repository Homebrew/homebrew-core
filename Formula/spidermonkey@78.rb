class SpidermonkeyAT78 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/78.15.0esr/source/firefox-78.15.0esr.source.tar.xz"
  version "78.15.0"
  sha256 "a4438d84d95171a6d4fea9c9f02c2edbf0475a9c614d968ebe2eedc25a672151"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 ventura:      "4a62a6dda8c66340da405782a610b4748044faecea1af581fd69397973db3427"
    sha256 cellar: :any,                 monterey:     "1708e27a5b11fe1dfe24310d08c01b289bc5c4e0c00e797efb29b97d0097ec1f"
    sha256 cellar: :any,                 big_sur:      "96797d1ed292a57ad3592f4da7186be0c67eef98668d2eb5d9208a0289d6c9f2"
    sha256 cellar: :any,                 catalina:     "a1dcf35d035ce67b0ff26470130d8e2a986ff85c169e1b8ebed5c6d86e086527"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6f0c131fa78090c6d5a4c731b9edc5b32581a62b26fd6c6a3345afde40e71af1"
  end

  deprecate! date: "2022-04-02", because: :unsupported

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
