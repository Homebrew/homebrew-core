class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-8.4.3.tar.gz"
  sha256 "946119a0b5f5c8f410ea21fbf6281e917e61ef35ac0aabbdd24e787470d06faa"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dd98fb64eb58505be9b69da927557c2bbe39ad593c1dd291b23942572802c9bc"
    sha256 arm64_big_sur:  "7b7ffa1f0d246ba88fa8d87aa0ab9e27b3f8c94c20f5810a8be6d395bec0ee1a"
    sha256 monterey:       "f020fd1faef1157a884e0d93d8c3630b94b8baa32b4c41c07b21207363a6d1c3"
    sha256 big_sur:        "4f5ad145ad5261f5102251cac8f018e8bae637dac859ecfb223d40e9d83e6626"
    sha256 catalina:       "e5a8bd1035745a6d1696a7a68a678b26a45ec52c253238269c32b72d8a2af45a"
    sha256 x86_64_linux:   "a69c6744215cc139bdf3aa25dcdc56841377ad355177c2e7fc6061e95ef7b418"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
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
