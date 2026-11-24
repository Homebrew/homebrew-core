class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-11.0.1.tar.gz"
  sha256 "f976bec4351143b7219bf1ba65a72e9a1183d44cd44813b944723b6df49db92f"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "6f4e3d9f6557c67054a8297d90a9ff3f60bc85a831e8d7c6980024ea1b4b8eb6"
    sha256 arm64_golden_gate: "58014b7c8277a966c3fdcd2c2bee042b2cc6c04e66c8f16b86d35df8bb5ed452"
    sha256 arm64_tahoe:       "77182356e2749d0b25a441eca813629638edd23af94394000e29fe9ecd72800a"
    sha256 arm64_sequoia:     "3f355b4f222dcaced54c367eea2d95f7eda6634d3e6390711b75a7bed511011c"
    sha256 arm64_linux:       "0fd1c030e41ab716f2c6a96dab7e908cee49042b636c32569c9d61d0c0e5b3c7"
    sha256 x86_64_linux:      "5729d8321bc8f82619be89b794210aef944a36fd813f9e9b0de526dbf07b8b22"
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
