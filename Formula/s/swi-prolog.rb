class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-10.0.0.tar.gz"
  sha256 "98c552c48fc8b44dcd4440abbfed632cceb75055fde267be12f340bea8106590"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3eb2ed1fa8a93f498210382896da6ca918c489cace86665db420f07b7ea0316d"
    sha256 arm64_sequoia: "066cc4c305cd8820c725b68e084d8eec5d56f556c6b3304ab3632e717af1997f"
    sha256 arm64_sonoma:  "517dcd86d7a0aa124e79a20970db315d5c11d2acae59235b8a606312ea563d24"
    sha256 sonoma:        "f77b39ec026c93f25242d419eafcedff13fed918391b8898b4fdb7c6e21b570b"
    sha256 arm64_linux:   "ced37bbbbdb1d01221253f4b644b4c8edaf2d3ceff1b2da5139cef9986bbec00"
    sha256 x86_64_linux:  "b533ea5641a7bb74e8734ba66a48036edc1fb28adaf2643d0ae993822e422eb3"
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
  uses_from_macos "zlib"

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
