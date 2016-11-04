class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.5.3.tar.gz"
  sha256 "404235eacd0edc0bb18cade161005001a7af11af3d447663ef57f61fe734dead"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e0491f0d90040d46c9ae24801d2eb330a47e27a8b53b5027044ce1785c141cf" => :el_capitan
    sha256 "3b1fd6ca8831b887d924d375d5ce974810bd2d6ee02ce812d35ed28e8e5cee8f" => :yosemite
    sha256 "4ba1ed7572832dd6e51be2bc6abf58e0a861e370b82007ed8d064f2eeca3ed91" => :mavericks
  end

  depends_on "xmake" => :build

  def install
    # Prevents "error: pointer is missing a nullability type specifier" when the
    # CLT is installed; needed since the command below is `xmake` not `make` so
    # superenv won't do this automatically
    ENV.refurbish_args

    system "xmake", "config", "--smallest=y", "--demo=n", "--xml=y", "--asio=y",
                              "--thread=y", "--network=y", "--charset=y"
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
