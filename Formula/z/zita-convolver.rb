class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.3.tar.bz2"
  sha256 "9aa11484fb30b4e6ef00c8a3281eebcfad9221e3937b1beb5fe21b748d89325f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html"
    regex(/href=.*?zita-convolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "27ab1f512bc3b1f0eec036f702eb55b9f0d14d720229f2eae6b029c827185624"
    sha256 cellar: :any,                 arm64_sequoia:  "4426fc8a54e7e24fa6227c1b38a0f0a8ad3d0957244ea5e29e1092b28f7cade5"
    sha256 cellar: :any,                 arm64_sonoma:   "5b3e06cb4fc6b39c91d964d8a5f960aa7c8a2715907978b26d6d6ab25c4705bf"
    sha256 cellar: :any,                 arm64_ventura:  "b080f0a633296bb349fb9c06858f0327c789113fd3b84c6b31a5ce213a67a0f9"
    sha256 cellar: :any,                 arm64_monterey: "0db7b44d8a6d714e4cdbc04121ab1df685469175bf30b42355122b87b8fa16bb"
    sha256 cellar: :any,                 arm64_big_sur:  "dd52351558f1a7d5860d8227ee71fb2fa28abf751adb4193dc63c8cb72f076ae"
    sha256 cellar: :any,                 sonoma:         "95aafd5ff8d7905f664c95046c2a0cf7f9d3490f941ac549f0d333d6354ca1fe"
    sha256 cellar: :any,                 ventura:        "f6d2fece841444ec39fa17717fc732f75feaf3e05b24fcfa1203abfdc89ec391"
    sha256 cellar: :any,                 monterey:       "b1eb48a11c3a0c13bcbbd30af63190fbec40e6ac97679d31c1fca4a7eb210a12"
    sha256 cellar: :any,                 big_sur:        "0e712ab784293d338e277912151e068c7117f902165e7e4dcdd231ba8b3767fd"
    sha256 cellar: :any,                 catalina:       "a616c118732c9f2c3775348e598a972abab7ae67b7cb0f283884cddaa55ce93d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4756b908b348d2b18c80ad68a255021c9545aa0d8dee560c7139b21b0185c15b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eb63c0ffaffec4c0e2f1798d73119eb4d124f97e421aa350ad8da0722ca5225"
  end

  depends_on "fftw"

  def install
    cd "source" do
      inreplace "Makefile", "-Wl,-soname,", "-Wl,-install_name," if OS.mac?
      inreplace "Makefile", "ldconfig", "ln -sf $(ZITA-CONVOLVER_MIN) $(DESTDIR)$(LIBDIR)/$(ZITA-CONVOLVER_MAJ)"
      system "make", "install", "PREFIX=#{prefix}", "SUFFIX="
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <zita-convolver.h>

      int main() {
        return zita_convolver_major_version () != ZITA_CONVOLVER_MAJOR_VERSION;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzita-convolver", "-o", "test"
    system "./test"
  end
end
