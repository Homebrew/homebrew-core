class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "https://tboox.org/"
  url "https://github.com/waruqi/tbox/archive/v1.6.5.tar.gz"
  sha256 "076599f8699a21934f633f1732977d0df9181891ca982fd23ba172047d2cf4ab"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0be436a7df4a7b942f37e397b2cc0929e64e9475fad74cb9fb8dd70d7d5b42a7" => :catalina
    sha256 "cf391788c014a7acac0d1e7ff4a4fea01e840dddeb4e901427fb5f40939f9157" => :mojave
    sha256 "8eaecc2a931b034521a468cc1410b01991139f631e8f888ccce60092d825af0c" => :high_sierra
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
