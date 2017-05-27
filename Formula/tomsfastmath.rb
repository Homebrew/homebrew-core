class Tomsfastmath < Formula
  desc "Fast, large integer arithmetic library written in C"
  homepage "http://www.libtom.net"
  url "https://github.com/libtom/tomsfastmath/releases/download/v0.13.0/tfm-0.13.tar.bz2"
  sha256 "8defe6f20759a455ade46b2f3c4de46d2358a6222236f78012736a6aeed63407"

  def install
    system "make"

    include.install "src/headers/tfm.h"
    lib.install "libtfm.a"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tfm.h>
      #include <assert.h>

      int main()
      {
        fp_int integ;
        fp_init (&integ);
        fp_set (&integ, 123);
        assert (integ.dp[0] == 123);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltfm", "-o", "test"
    system "./test"
  end
end
