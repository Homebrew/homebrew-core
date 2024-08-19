class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.6.tar.gz"
  sha256 "0cb9b80b9922be8165cbac384ebe050d94553e72cf7aebfc980b4395ff01d05d"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "598510b76bdd7c3ee65e3c1d2985850c3f1b834281519baac226ea169563e138"
    sha256 arm64_ventura:  "03ce4c8fdf6ec2b5a75eb4df3c119c300b0caa0d39156d0effc993599b80e78d"
    sha256 arm64_monterey: "204c7827acde178b0fb678b6b2c25bec2a72c805acf9407004b9337dfe8bd349"
    sha256 sonoma:         "edd11320e42b5c60fcde748d0aa428938de247b2240891bfd0fb7972c5b36403"
    sha256 ventura:        "69e94bd7577e284142e7c70d73f4951bd230dffdb5469a70f38d8fd120439fec"
    sha256 monterey:       "01aaa112ea8cc27ee03a51a14b60e01b770bc48d88e430e5bf65f9605774f1a1"
    sha256 x86_64_linux:   "3e49ccb6979769ac7fe2540aa0ae3f7c9fa9fad564e91700138a6277554bbed9"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
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
    args = %W[
      -DSWIPL_PACKAGES_JAVA=OFF
      -DSWIPL_PACKAGES_X=OFF
      -DCMAKE_INSTALL_RPATH=#{loader_path}
      -DSWIPL_CC=#{ENV.cc}
      -DSWIPL_CXX=#{ENV.cxx}
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
