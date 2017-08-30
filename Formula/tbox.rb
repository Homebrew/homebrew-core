class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.6.2.tar.gz"
  sha256 "26ede7fd61e33c3635bf2d6657ae4040a4a75c82a5da88855fd965db2f834025"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea7c48b6fe2b39bab5eed10e69cec5bd0082f7113d27288e31ddf337928b7ece" => :sierra
    sha256 "8af4c08809e12a4717cf5ea229d9eecd5e1409bb9bafe37942c4a7c9101011b1" => :el_capitan
    sha256 "6a55d97930ce0cc3e62dfbc8a9438243e8d9020757ebaf0dbab532f80587b3d8" => :yosemite
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltbox", "-I#{include}", "-o", "test"
    system "./test"
  end
end
