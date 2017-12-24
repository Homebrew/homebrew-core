class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://bioinf.spbau.ru/spades/"
  url "http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1.tar.gz"
  sha256 "3ab85d86bf7d595bd8adf11c971f5d258bbbd2574b7c1703b16d6639a725b474"

  bottle do
    cellar :any
    sha256 "717c5721c4b7db0d460bbf6ad8ccaf2c31cad64944486b1665e99f56559747cb" => :high_sierra
    sha256 "f4088116abe4ad83840e2849ffdb55ee6dc58469398bd90d23c703a143677595" => :sierra
    sha256 "09de6dbd2351fa82ba7bc4126a402e4712168282159eff66ad73a57751cef1fc" => :el_capitan
  end

  depends_on "cmake" => :build
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
