class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.6.2.tar.gz"
  sha256 "26ede7fd61e33c3635bf2d6657ae4040a4a75c82a5da88855fd965db2f834025"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f0f21bf74192941533d179299f25027727c7e9f6f1478462d10762112a5cc09" => :high_sierra
    sha256 "06b1ebd6756e7bb2cedf152a5cf41b127fdeac7c4ac070bb6b70dc286aebbed3" => :sierra
    sha256 "fa1644f34db9e0e187448f06d5400c88493612dc1b78608dabcaff7eab6661a6" => :el_capitan
    sha256 "b9c2d0df34fc3062f4963765fe2524cd5378ad126f2f611d971b5efd7c727c75" => :yosemite
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
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
