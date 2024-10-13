class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.2.7.tar.gz"
  sha256 "fd4126f047e0784112741a874e2f7f8c68b5edd6426ded621df355c62d18c96f"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "0256218f3dc51378aecb9c831103aef1d49bdef503556485b0e5e63a03949541"
    sha256 arm64_sonoma:   "82389e702458b8a7f324b1d4e390ee292501e7c9e5e3b7d50f2ad09656061998"
    sha256 arm64_ventura:  "1289209e2994b1c842d8d7b3e83255f803023742883998a25c79f884627debb2"
    sha256 arm64_monterey: "15609488c0cd29f1b538504d48638e6af1231afd5e30f18d8b928c4d2a945079"
    sha256 sonoma:         "0a49327bf13f589c5bb9148c6cc526c7967bd332ee499fc0aba78e22e892dcd5"
    sha256 ventura:        "de02dd3ba44d512c9b0633c34a7cae6ac8296c587ce75c0ec76bf7051b0265f9"
    sha256 monterey:       "3102c2046092c844dd7001ff8efff41e80cdd605109a208e654cc804b1d3a4fa"
    sha256 x86_64_linux:   "0ef620824a06927b9e03069db15f1ec7975e42b1ba4f8a1e0347fc8188a531ae"
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
