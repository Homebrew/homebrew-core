class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-11.0.0.tar.gz"
  sha256 "64b9e2b8a862ee56dd54cf6820775111afc87310511c8f03f6fd978614e37c33"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0d8ebaedaa599a6a2d54cc5f7d0cb5c4d7cbf8f2d75d3e8eae117a8a74985561"
    sha256 arm64_tahoe:       "cf33193ff0af261435e5c78b9a101e390ca471e494a577f491a2da663d7a4cc7"
    sha256 arm64_sequoia:     "eca912798a18514f14dd988aa616ba94b642b4c8b23a283902dd5f0a13376260"
    sha256 arm64_linux:       "862ea1bc754ccb47441d2722c01e06221c56e6f703209e29d6a4055c430e3b07"
    sha256 x86_64_linux:      "8368e098618e31acf4eeab0098c75d64c54104b3235b2980b5d2f11672f1a7d1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "unixodbc"
  depends_on "utf8proc"

  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
