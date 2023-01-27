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
    sha256 arm64_ventura:  "3df03320f6702fff05bef68d6ce1c2bbac59ddefaa264d324af5e1d880bae9d6"
    sha256 arm64_monterey: "c5d50d9125a09585f6c2f0ab3d45ab5d084e3d554f1f7f2ded66ac4853452526"
    sha256 arm64_big_sur:  "02b37cf09b14e97a36ef9623f62e78d9b67186af33c2e3d87fbd7f48f0143f8c"
    sha256 ventura:        "c7afcab31d2f0cc5b0ae8f849db1d143f34c9bed0db8dfd41dfb77cb61783a9c"
    sha256 monterey:       "64aedf69e5e1e56b6f4efa37790a963ae6dfcb1eaf4463bd307504b268c48c09"
    sha256 big_sur:        "63fcb4b565a7b3eda277f282d2f6e3141b6e80b1e7db754dfbab10cbb46f6198"
    sha256 x86_64_linux:   "b438b58997eb6507cc99f557ecbabc6b5427e2bfaefc084c563f6ff8666ddc88"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
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
