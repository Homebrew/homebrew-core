class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.3.tar.bz2"
  sha256 "9aa11484fb30b4e6ef00c8a3281eebcfad9221e3937b1beb5fe21b748d89325f"

  bottle do
    cellar :any
    sha256 "8bddd7f214f291349d0600da5d6f9062091f2c8c0dd14d59833bce6f070f4e74" => :catalina
    sha256 "affeedb6852f411c86d7219df7614a1d308e8d46c703cb2dc914188593a79076" => :mojave
    sha256 "d65f312660d0ca92081a0d217a696a8e03a64f604f6924cd95b9e7a4956979f6" => :high_sierra
    sha256 "39433124f4b7d8fa9b6eb20f40708ba9ded27322049b09178f3a3ef8e5ce5c1e" => :sierra
    sha256 "d040044f83b7cd6d2bc2e4d8625a38c08820723744b9a653fc23fc9e3f33e5d2" => :el_capitan
  end

  depends_on "fftw"

  def install
    cd "source" do
      inreplace "Makefile", "-Wl,-soname,", "-Wl,-install_name,"
      inreplace "Makefile", "ldconfig", "ln -sf $(ZITA-CONVOLVER_MIN) $(DESTDIR)$(LIBDIR)/$(ZITA-CONVOLVER_MAJ)"
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX="
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
