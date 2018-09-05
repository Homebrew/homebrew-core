class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.0.tar.bz2"
  sha256 "e3186f807dd76befbbb1c009f6bb4f83567b5d3c93b49a71b334034d1171a73b"

  bottle do
    cellar :any
    sha256 "affeedb6852f411c86d7219df7614a1d308e8d46c703cb2dc914188593a79076" => :mojave
    sha256 "d65f312660d0ca92081a0d217a696a8e03a64f604f6924cd95b9e7a4956979f6" => :high_sierra
    sha256 "39433124f4b7d8fa9b6eb20f40708ba9ded27322049b09178f3a3ef8e5ce5c1e" => :sierra
    sha256 "d040044f83b7cd6d2bc2e4d8625a38c08820723744b9a653fc23fc9e3f33e5d2" => :el_capitan
  end

  depends_on "fftw"

  def install
    cd "libs" do
      system "make", "-f", "Makefile-osx", "install", "PREFIX=#{prefix}", "SUFFIX="
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zita-convolver.h>

      int main() {
        return zita_convolver_major_version () != ZITA_CONVOLVER_MAJOR_VERSION;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzita-convolver", "-o", "test"
    system "./test"
  end
end
