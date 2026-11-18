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
    rebuild 2
    sha256 arm64_golden_gate: "10fcaf0f3d633f8321a2c9f0a2663f81497fc814918a64e3be9f73b7eebefaed"
    sha256 arm64_tahoe:       "a8f6c8b08a159d40d071df244c9f9f346741820a4f17015398fc47872e765e6f"
    sha256 arm64_sequoia:     "f0fcaea1c6c5393d63e45d5e8f843e587936ec0c3dd668ce5b211222da28d923"
    sha256 arm64_linux:       "bd56b397c7384d3a92fccc12ae55fcdc506445d6e2b348852f09d48cefe4876d"
    sha256 x86_64_linux:      "227daf585ace6d5a86bed58f53f15e458d6bd744edc0db1cff68cfbf89054f14"
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
