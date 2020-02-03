class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.0/SPAdes-3.14.0.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.0/SPAdes-3.14.0.tar.gz"
  sha256 "18988dd51762863a16009aebb6e873c1fbca92328b0e6a5af0773e2b1ad7ddb9"

  bottle do
    cellar :any
    sha256 "4761b8cfbaca36fdc4fac08b8122f5519415d86668355224a67c52a5191ae7c5" => :catalina
    sha256 "f3e29120ab665892ba68d2d7c7522b1fea866a2d405f59547071d8c6c31318c8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "python@2"
  uses_from_macos "readline"
  uses_from_macos "zlib"

  def install
    # Use libomp due to issues with headers in GCC.
    libomp = Formula["libomp"]
    args = std_cmake_args
    args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
    args << "-DAPPLE_OUTPUT_DYLIB=ON"

    mkdir "src/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
