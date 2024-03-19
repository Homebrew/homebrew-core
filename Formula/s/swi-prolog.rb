class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.2.tar.gz"
  sha256 "896fd51196fd3becd574486da75a924f272e8d63332459292b305986cf101fc3"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "788bad7327204936d14fc159337fa82dddc4ff9b9320ad46bdedbb7b0b9b4fe2"
    sha256 arm64_ventura:  "2c08d6d0fc6319b9061aa6e94b96e5c7745418980a941024427847e2c48d20a3"
    sha256 arm64_monterey: "e97e5eafbdc531a45b6088761c4594b4fd8c92bd62763cbc1bf253a38e22d669"
    sha256 sonoma:         "83148ede33109fa847c35b70b1481cc4b1414039a1781c1403daec29ef33a7e9"
    sha256 ventura:        "0743fb79bd11227697493bc71c0777d347207d4a1767489c347f5581642c68f6"
    sha256 monterey:       "4adcb6f4a6454f96d86f7b80c29b3c02e4ec9f39ff6ed0c7a4c8df2f03466378"
    sha256 x86_64_linux:   "391abffe2fbdc5b395cb6d3f33eaaf411b7e5cc3e8f4050c51708370b9b64819"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
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

    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
    ]
    if OS.mac?
      macosx_dependencies_from = case HOMEBREW_PREFIX.to_s
      when "/usr/local"
        "HomebrewLocal"
      when "/opt/homebrew"
        "HomebrewOpt"
      else
        HOMEBREW_PREFIX
      end
      args << "-DMACOSX_DEPENDENCIES_FROM=#{macosx_dependencies_from}"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
