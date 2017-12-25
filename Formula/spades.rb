class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"
  revision 1

  bottle do
    cellar :any
    sha256 "33703ec0e665cfdb383134a3acd52c2422a21b141f7bf7b5817f4ddcfb9dd68b" => :high_sierra
    sha256 "a243edfa5fc7ac9f76749ded4ba508b6edd020ff937fa0f5e7b35af14af1a91b" => :sierra
    sha256 "61f9df50e6d477e5363790e19a8a2a273f7dddbbafc2205739487d0141ae330e" => :el_capitan
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
