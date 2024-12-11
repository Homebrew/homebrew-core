class VoAmrwbenc < Formula
  desc "Library for the VisualOn Adaptive Multi Rate Wideband (AMR-WB) audio encoder"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz"
  sha256 "5652b391e0f0e296417b841b02987d3fd33e6c0af342c69542cbb016a71d9d4e"
  license "Apache-2.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vo-amrwbenc/enc_if.h>
      int main() {
        void *handle;
        handle = E_IF_init();
        E_IF_exit(handle);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lvo-amrwbenc", "-o", "test"
    system "./test"
  end
end
