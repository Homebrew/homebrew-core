class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  stable do
    url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.4.tar.gz"
    sha256 "feb2815a51d34fa81cb34e8149830405935a7e1d1c1950461239750baa8b49f0"

    # Backport fix to build on Sonoma
    patch do
      url "https://github.com/SWI-Prolog/swipl-devel/commit/1e51805f04ea9cb13cf01e5b7a483c03d253b24c.patch?full_index=1"
      sha256 "628b65b3e4a49c8dda4b97824ad05359c48bd27e7e4ddbf914e3da57ef7c87ee"
    end
  end

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sonoma:   "c586362f4fe7bacc7de100e46c8a16831ad565d383443fba6b415967f6caade9"
    sha256 arm64_ventura:  "3fc7572f82e10db175c038325dc3b46b490574967df55061715699162d5901b9"
    sha256 arm64_monterey: "57d49f4c57aba588338fa17522a5f6abc6f7ac6cc784750ab4aa2890bb97facc"
    sha256 sonoma:         "ab1f7f6233e16dd476ffb50ef5d6340a51a4d03549a5b01663fc0696d717fca7"
    sha256 ventura:        "33447d4e07c9c03bd3d804e33e29cc608532e6541a21bca93c10c2e0f1f4e215"
    sha256 monterey:       "fbb3c93fe141f5b54e7d2dd9a743330b14ad51ba154485767cf5c8848971ad56"
    sha256 x86_64_linux:   "9b22644cc92919fb6c704410fd944191d2af73b9f2afbc028ed18b72a708fb3d"
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
