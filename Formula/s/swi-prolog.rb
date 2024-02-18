class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.1.tar.gz"
  sha256 "77e8884d8330e1f6c91667400ea8721640f47c214061d3476ac469e9ad63eeee"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e7a390d639f31f99c466602c07ab910f3f503656107d1501cf5272848ec501c8"
    sha256 arm64_ventura:  "7359353389945db44ca7e55c22815270e722afe6965451efeb5bbd7f77ce60ee"
    sha256 arm64_monterey: "1fccde5c05a6f69bdabab32b129c2086ed74f8c4eeae5c7184cc1b9d636ac087"
    sha256 sonoma:         "a1a782da2b320ab79c096214d0df9373e64e63a5753d14bfc24b95b3d3636362"
    sha256 ventura:        "67a05106b8e2c44ec3650928dd3ebfcddc83a809676d57eb9a215f2aa493c5db"
    sha256 monterey:       "f643185d485ae2e6d87b7021665209bdd6b2004d5631cc637b830e3c83d0a6f1"
    sha256 x86_64_linux:   "5f13f952f39a1fdc4d5149d1506d8fd2f95ec08ba73cd420afb4b845f997620f"
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
