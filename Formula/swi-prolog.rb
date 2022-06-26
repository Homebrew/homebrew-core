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
    sha256 arm64_monterey: "b76a775bacf401e61dc4a075d870accdcf2ce05563be15a45384a83575469938"
    sha256 arm64_big_sur:  "8f81a93c9e15407c4df34d7a57abd5bb7b3b24f165859c5b1d7078a2e9636e17"
    sha256 monterey:       "8a612e9be7e4bd33580d0e4c88b7241e83e618c594da1ee73b87a6f79fde2b9b"
    sha256 big_sur:        "243131fe5917d269242e3ba81cd2579c73365dcb765cccb76bd7bd58c2cb1051"
    sha256 catalina:       "971367f3c09223fa38fac0978422516c1bf9829b20565d79dc5ceed85b41bd8a"
    sha256 x86_64_linux:   "eca321dd1ec862ea54ec84798be3a1ccd281499ae3258d1ebb7386064c6a484d"
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
