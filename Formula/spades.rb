class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.12.0/SPAdes-3.12.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.12.0/SPAdes-3.12.0.tar.gz"
  sha256 "15b48a3bcbbe6a8ad58fd04ba5d3f1015990fbfd9bdf4913042803b171853ac7"

  bottle do
    cellar :any
    sha256 "78874d080a73cb1857695748ce7d92b14835689397682171fa9b5649de15ff69" => :high_sierra
    sha256 "9108c70c0f648e7222d7ca09cc034eabc7e3f22eaa0a7d72a311458b4d95373b" => :sierra
    sha256 "8c9762bec98f635611d8d880ff81065e8c01568da0dd2cb59870c77e307d9c6f" => :el_capitan
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
