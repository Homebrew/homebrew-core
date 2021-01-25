class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.6.tar.gz"
  sha256 "13b8fa0b10c2c0ca256878a9c71ed2880980659dffaadd123c079c2126d64548"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc5612421cbec4955e8a99ee3cb9e214842cbb942384c4b1cd44d7d302a54137" => :big_sur
    sha256 "999ed2823cd0b81af561f0fb16e63f36be40db4e11cf9835e09a75295a3a64eb" => :arm64_big_sur
    sha256 "1993c672049429417dd5e0ccef97be5b8aee4c5120b8d925a90dc708f10d2540" => :catalina
    sha256 "c325bd6d49a9bdbf667af3a15cbcec4c171e2d71b7dc0c21d4f45906912aabaa" => :mojave
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
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
