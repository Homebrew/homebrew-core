class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 3

  bottle do
    cellar :any
    sha256 "223ae1240164641e14120345c768d166fa4adfbd9368ee70e0acef1700cc91d2" => :high_sierra
    sha256 "6977379e053ba4b8784e20df6103ac950bff11cbc159178404f321198f8fb156" => :sierra
    sha256 "2bd814781ddaca6f9187c75dc06ae699f4ec51647aa569180aa50fa6e1980d6d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "python@2"

  # Fix compilation with GCC 8.1 and later, remove in 3.12
  # https://github.com/ablab/spades/pull/106
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cbb208e3/spades/gcc8-fix.diff"
    sha256 "9d0bb51570d0619d3dae0191695eebec60da392d2d38fdc464b1fd063173ca07"
  end

  fails_with :clang # no OpenMP support

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
