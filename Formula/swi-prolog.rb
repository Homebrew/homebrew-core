class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.0.tar.gz"
  sha256 "d607733a776ca56b3ecb2118119d4ae08a8790ef4aaa08bbe8f2279f34fba4b8"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "0308f7558585c095f79a8ee2b3175301d0ee5910735cd0c23b0f2bf5cc59815a"
    sha256 arm64_monterey: "144300728e472a4668e9ad3922d46d07f3a3e17a46b0616db450cf8125f4ad32"
    sha256 arm64_big_sur:  "391a851cdeb4bcbe04afc8b8a745b0ffcedeb8f736b4f80af55d2da122334c4e"
    sha256 ventura:        "a8b5f07828569ea9686697a5c3cb945ffcbbcfd04931499bda28bcc9e7affac0"
    sha256 monterey:       "35f2587b2c732d65b5b103271d6b7b19c11f8a6318b7cbd9ccb0c96020275b10"
    sha256 big_sur:        "30702cd5edcb9ff0547d84e837db896b88cd7b14ccffd9b1170f2728a0e0ae40"
    sha256 catalina:       "88aa2442c73d9dcc67a19933a899b95f148aaa66615f93753809ddc78a2e9043"
    sha256 x86_64_linux:   "d3c80548aa6b47dfb87bb083cbd6cb125f787354372ae7d6bcf7fa4b3dce0029"
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
