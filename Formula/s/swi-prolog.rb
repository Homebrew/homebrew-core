class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.5.tar.gz"
  sha256 "b9f40771906c7e04be80ae4cfaa4463aeb44c52010a478edd8c7a4c022fe8781"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b657b87c02eb0a385d79dbf8b415aed5ef8aabc7bef0ec9547bd56cc8fa58e3a"
    sha256 arm64_ventura:  "89fc592bc24b4c7f47ef4db217b104fdfd75b7b78b28321469d062f32f0861b6"
    sha256 arm64_monterey: "07f586ff3b27f809edd0e1e1f9d864f6f561759454174c986de41dba55c2d54b"
    sha256 sonoma:         "26620176683f88d736ab01a9f7bc3581b0c458a0727f43693f182d7ae4695faf"
    sha256 ventura:        "b1b4e2ee7233d18eef283778e63fd50f21446ef90ad4dd6054e8d85d92b831bc"
    sha256 monterey:       "f72e089ea3fccf490179e741114bd2dd9f9b2c7a0cefa91e9121f9af6ab0168a"
    sha256 x86_64_linux:   "c7466bc52ec4754a445ae902a5a8a7fc95e601d89470b2ff4cece78d37b3c805"
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
