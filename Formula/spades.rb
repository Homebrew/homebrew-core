class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.13.0/SPAdes-3.13.0.tar.gz"
  sha256 "c63442248c4c712603979fa70503c2bff82354f005acda2abc42dd5598427040"

  bottle do
    cellar :any
    sha256 "6040a9bd289a6da30bc4b47f0d9a484355604d38ccfa91973d023dfc92e266b8" => :mojave
    sha256 "92dfcc3091aabc822284cba8384d4a18c0f59d1bc297d5052a346a584814794e" => :high_sierra
    sha256 "7d5a1293aeb3be0efddd29836095d6610e42bb8000f39b5785f5b2f32aada243" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"

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
