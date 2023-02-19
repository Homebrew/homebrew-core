class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.4.tar.gz"
  sha256 "feb2815a51d34fa81cb34e8149830405935a7e1d1c1950461239750baa8b49f0"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e68d396b1fdc0e15ae49ab64af00bb77daad6064932daacb42e666bab902d36a"
    sha256 arm64_monterey: "6c11129a2e337b7239efda15ee0b342f982e4ded180a468e0e9ea6b27e987af8"
    sha256 arm64_big_sur:  "92033e7096a74e8f2656eef2ef94377d7de7057959453e989f8984ca7536ba2e"
    sha256 ventura:        "d48fcdb3fe358b79619c1d301fe76977c1ecb274cb0111ef2968251be6372e58"
    sha256 monterey:       "3b5880ab3fc580cb9e01f3a874185f8d9065f83302a4735da22f85f3b0b18e3d"
    sha256 big_sur:        "65c8fe85fe1cc2ba1dbd66cbfff34e2b05f15494e57acffcce604aa2b6e53b25"
    sha256 x86_64_linux:   "d1057a373529b0c322e2f023fd3e40db57ba7e54c5ad7b7b3eb7655651f7300e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"
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

    args = ["-DSWIPL_PACKAGES_JAVA=OFF", "-DSWIPL_PACKAGES_X=OFF", "-DCMAKE_INSTALL_RPATH=#{loader_path}"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script (libexec/"bin").children
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
