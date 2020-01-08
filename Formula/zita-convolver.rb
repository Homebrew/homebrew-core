class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.3.tar.bz2"
  sha256 "9aa11484fb30b4e6ef00c8a3281eebcfad9221e3937b1beb5fe21b748d89325f"

  bottle do
    cellar :any
    sha256 "a616c118732c9f2c3775348e598a972abab7ae67b7cb0f283884cddaa55ce93d" => :catalina
    sha256 "e9bfda6d2d3119f93ea0d570b9b3516d44513c3eafc206543f8fb055707db8fd" => :mojave
    sha256 "b8b3326ead45ef0e126488d9c96a181f15888a11b707278c61c2ceeee312b37d" => :high_sierra
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
