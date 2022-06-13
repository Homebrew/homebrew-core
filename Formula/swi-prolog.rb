class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.4.2.tar.gz"
  sha256 "be21bd3d6d1c9f3e9b0d8947ca6f3f5fd56922a3819cae03251728f3e1a6f389"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "139513fc8927d079f0b78a67b532596753680992f49a2695aed9efe7c98f1397"
    sha256 arm64_big_sur:  "65783eed3844c8e5291d118edfe5fe62a76159cd6633b2c77952baf376bb30e4"
    sha256 monterey:       "ca133c29a855fdd87964128d30a33b135827a87e5b4dc38324b72d25f1abcf38"
    sha256 big_sur:        "d3ba87e54537f8da87bbf6b60c0054706fac316ffd60ff4fb7300dadd05a8e64"
    sha256 catalina:       "bc4eed487d3f941713cd01091962cc258d81962373ee5b3186fa616955479715"
    sha256 x86_64_linux:   "0a185f53a0e73890c03d0e45135db8cdbc72171c325c4cb7b2d2ff71687b8661"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = ["-DSWIPL_PACKAGES_JAVA=OFF", "-DSWIPL_PACKAGES_X=OFF"]
    args << "-DCMAKE_INSTALL_RPATH=@loader_path" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec), *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
