class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.6.0.tar.gz"
  sha256 "4f17646eb6623ca4331dc9e7d1163ff6969af58070b7392bab217f194384e0c2"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dc65f1e5f0d2e8e46451c38ca926ee7f85eae504eda5b4bd21acb79da93275d" => :sierra
    sha256 "f412506c78824f3bb40adfd51cd5c6073eec0a17db490bd6166aeeed4b5626c1" => :el_capitan
    sha256 "942bb7bc49c770e7b7e6cd685aa4ad15a7c047458b1e596fe8f3432a96e772f4" => :yosemite
  end

  depends_on "xmake" => :build

  def install
    # Prevents "error: pointer is missing a nullability type specifier" when the
    # CLT is installed; needed since the command below is `xmake` not `make` so
    # superenv won't do this automatically
    ENV.refurbish_args

    system "xmake", "config", "--charset=y", "--demo=n", "--smallest=y",
                              "--xml=y"
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
