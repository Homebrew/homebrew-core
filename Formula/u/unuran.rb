class Unuran < Formula
  desc "UNU.RAN - Universal Non-Uniform RANdom number generator"
  homepage "https://statmath.wu.ac.at/unuran/"
  url "https://github.com/unuran/unuran/archive/refs/tags/unuran-1.11.0.tar.gz"
  sha256 "428142a27d10c28df975b9ff93fe56cae3b5fc8a"
  version "1.11.0"
  license "GPL-2.0-or-later"
  head "https://github.com/unuran/unuran", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gsl" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--with-urng-gsl", *std_configure_args
    system "make"
    # system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unuran.h>
      int main() {
          UNUR_DISTR *par = unur_distr_normal(NULL, 0);
          if (par == NULL) return 1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lunuran", "-o", "test"
    system "./test"
  end
end
