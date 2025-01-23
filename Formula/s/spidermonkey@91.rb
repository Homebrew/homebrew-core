class SpidermonkeyAT91 < Formula
  desc "JavaScript-C Engine"
  homepage "https://spidermonkey.dev"
  url "https://archive.mozilla.org/pub/firefox/releases/91.13.0esr/source/firefox-91.13.0esr.source.tar.xz"
  version "91.13.0"
  sha256 "53be2bcde0b5ee3ec106bd8ba06b8ae95e7d489c484e881dfbe5360e4c920762"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2ecaf8e4212260b4f579a7fc466f78615adfae5c7a0e99d1976a39568fc24e6b"
    sha256 cellar: :any,                 arm64_sonoma:   "67ab8a1a5b3c43e1b0c8b28e261ac6f584ae03a18d19a0279cea2ca7cfb054d0"
    sha256 cellar: :any,                 arm64_ventura:  "a4b5607569f9d86bb90f204337c362a1e63a5333669ca3ecd2b90a945ca3d15c"
    sha256 cellar: :any,                 arm64_monterey: "6b646df4501dc6a8ac9e0ea5dd7fb604ef28177f0f67e06422fdf30176fd8fc4"
    sha256 cellar: :any,                 sonoma:         "1f73995d267a3d0dbee5a05e64c6a227006e3491c9ccd0d7b4927cf50b21e170"
    sha256 cellar: :any,                 ventura:        "bdafb8a4478924f90059fbe30c727e8127cb6c220f08a5c2290b68a1d4e8808a"
    sha256 cellar: :any,                 monterey:       "0e82c03130747ffd00d9142350d60b6f8e532854666c6fe1164b34452b275992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae8f67dc53fa55e1d06ee912bd04ee344c6d742210c401bc1dfae9410d198eaf"
  end

  # Has been EOL since 2022-09-20
  disable! date: "2024-09-09", because: :unsupported

  depends_on "autoconf@2.13" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  # Can uncomment after https://github.com/Homebrew/homebrew-core/pull/192986
  # as existing bottles are linked to ICU4C 74 like
  # #{HOMEBREW_PREFIX}/opt/icu4c/lib/libicudata.74.dylib
  # TODO: depends_on "icu4c@74"
  depends_on "nspr"
  depends_on "readline"

  uses_from_macos "llvm" => :build # for llvm-objdump
  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  def install
    # Help the build script detect ld64 as it expects logs from LD_PRINT_OPTIONS=1 with -Wl,-version
    if DevelopmentTools.clang_build_version >= 1500
      inreplace "build/moz.configure/toolchain.configure", '"-Wl,--version"', '"-Wl,-ld_classic,--version"'
    end

    # Avoid installing into HOMEBREW_PREFIX.
    # https://github.com/Homebrew/homebrew-core/pull/98809
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Remove the broken *(for anyone but FF) install_name
    # _LOADER_PATH := @executable_path
    inreplace "config/rules.mk",
              "-install_name $(_LOADER_PATH)/$(SHARED_LIBRARY) ",
              "-install_name #{lib}/$(SHARED_LIBRARY) "

    inreplace "old-configure", "-Wl,-executable_path,${DIST}/bin", ""

    cd "js/src"
    system "autoconf213"
    mkdir "brew-build" do
      system "../configure", "--prefix=#{prefix}",
                             "--enable-optimize",
                             "--enable-readline",
                             "--enable-release",
                             "--enable-shared-js",
                             "--disable-bootstrap",
                             "--disable-debug",
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
