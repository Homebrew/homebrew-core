class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-10.0.1.tar.gz"
  sha256 "a9504745310e36195cf8cee9ad9164a7aa99e389c669ca6d279e321efc2ad9d4"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ec138c06b1b609386119a1a01de26d4a2d13c220b35087772f3f617cb6757f82"
    sha256 arm64_sequoia: "8097c8070826fc200a90f7f5275133520bb06b188b220ced7b91cf60972aef8e"
    sha256 arm64_sonoma:  "3150968bdca7001398fbcbe8fa440c49257ac6ffe107df2a177c33ead61081f6"
    sha256 sonoma:        "10a5ebed010d3892c549e2a2bf614dd943698f60f67209f272573e2e350c0b0d"
    sha256 arm64_linux:   "d63fb5ffd077083e93a2c3de24bcbcb6720ca6d05249c0eb373f3fd38591f2ec"
    sha256 x86_64_linux:  "9822768754b2e7fb206050ab4b3c9950768920477166e142dd8441f8451e97ba"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "unixodbc"

  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove bundled libraries
    rm_r("packages/libedit/libedit")

    args = %W[
      -DSWIPL_PACKAGES_GUI=OFF
      -DSWIPL_PACKAGES_JAVA=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
      -DSYSTEM_LIBEDIT=ON
    ]
    # Let Homebrew's build environment handle dependencies
    args << "-DMACOSX_DEPENDENCIES_FROM=None" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~PROLOG
      test :-
          write('Homebrew').
    PROLOG
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
