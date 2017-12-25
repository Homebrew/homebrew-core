class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 1

  bottle do
    cellar :any
    sha256 "2d9219640eae5c89e530aee5142ede6ab3e0ba275a5f3159ec43c3705463595e" => :high_sierra
    sha256 "5b0dd5da71f046f0be08c97e726f269ed2dbc45a5f7a9f0b46b60f2cadb6adc3" => :sierra
    sha256 "fb825a55d4438fc332b19f5283aa0e04b6d782cdf845589d6037136fb01c6be7" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on :python if MacOS.version <= :snow_leopard

  needs :openmp

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
