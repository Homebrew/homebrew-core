class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.12.0/SPAdes-3.12.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.12.0/SPAdes-3.12.0.tar.gz"
  sha256 "15b48a3bcbbe6a8ad58fd04ba5d3f1015990fbfd9bdf4913042803b171853ac7"

  bottle do
    cellar :any
    sha256 "223ae1240164641e14120345c768d166fa4adfbd9368ee70e0acef1700cc91d2" => :high_sierra
    sha256 "6977379e053ba4b8784e20df6103ac950bff11cbc159178404f321198f8fb156" => :sierra
    sha256 "2bd814781ddaca6f9187c75dc06ae699f4ec51647aa569180aa50fa6e1980d6d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "python@2"

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
