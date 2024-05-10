class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.4.tar.gz"
  sha256 "d53cc13380b60ec4edeea0caead26af4d0e6bd877f458cf4fc6d6f90bd6e987c"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d641512f763bc8ab4f4be03649e976c2d92c00308046bb817a035ce85f200efa"
    sha256 arm64_ventura:  "1ad8de37e3445deacc388aabd675192c2ae9d86eb108ed407f9f280a4f96b073"
    sha256 arm64_monterey: "d6da5ca5ff34eee492fa6ed3d72eba4a739e82a4b3d893dacc9643dbab913ee8"
    sha256 sonoma:         "ed7169c1c0db59ee728ee80559d23eb9ea05f490952176a5929b231d0d6ee28d"
    sha256 ventura:        "11e585f67d28b29701938bdda55b4d4be946ab347f4da7c353499511b8e4f20d"
    sha256 monterey:       "0917886fe6ec78f14b0df9dc0fd2ad4a1d19d71c0193170390068db6fa41237c"
    sha256 x86_64_linux:   "2a9a6c38204a88bf54b3d30e4cea8bdec643e0cc9a577a22299c5d0813cdc1ab"
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
