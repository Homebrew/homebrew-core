class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.3.tar.gz"
  sha256 "28329039526a93c10a160be5c7d90ca4fb7d1514e4a009a0852c6d237292e724"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "587d8892a0c2fa9dd708f1b90b26fa76427cca4fe9baa5c4625ff1b769a1b587"
    sha256 arm64_ventura:  "af4b1566b462fa4ea94cf4a4b829d837db898b9bc719e91c88ddeaeb8935f0ec"
    sha256 arm64_monterey: "44c77bf04c90b5a8732991ec79e83e647c4590f69474fca2cbeb02f40b9522e8"
    sha256 sonoma:         "533d6cb1c2abd1aa8b88f09bbe134bbf8c4d23987a3d10808f8125ecb24c09ec"
    sha256 ventura:        "f02011002b8269f05f0ae4c803cb54e4015476518528e2b761b83470935eff56"
    sha256 monterey:       "2bbc8c315b1983bf0dab6e8655da4b1e847eb45ccba0f4d3b4683da9cf92654d"
    sha256 x86_64_linux:   "0e394cf133d77144a7be29676cd27d9d59cc0849facb95882bf519e01bb431a8"
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
