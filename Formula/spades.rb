class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.13.1/SPAdes-3.13.1.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.13.1/SPAdes-3.13.1.tar.gz"
  sha256 "8da29b72fb56170dd39e3a8ea5074071a8fa63b29346874010b8d293c2f72a3e"

  bottle do
    cellar :any
    sha256 "4761b8cfbaca36fdc4fac08b8122f5519415d86668355224a67c52a5191ae7c5" => :catalina
    sha256 "f3e29120ab665892ba68d2d7c7522b1fea866a2d405f59547071d8c6c31318c8" => :high_sierra
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
