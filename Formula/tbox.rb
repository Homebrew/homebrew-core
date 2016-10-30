class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.5.2.tar.gz"
  sha256 "c470a8a5b8f84d928d83af87c8f69c87ec9ecb6f89017bef93dc0d188e91a8c6"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e0491f0d90040d46c9ae24801d2eb330a47e27a8b53b5027044ce1785c141cf" => :el_capitan
    sha256 "3b1fd6ca8831b887d924d375d5ce974810bd2d6ee02ce812d35ed28e8e5cee8f" => :yosemite
    sha256 "4ba1ed7572832dd6e51be2bc6abf58e0a861e370b82007ed8d064f2eeca3ed91" => :mavericks
  end

  depends_on "xmake" => :build

  def install
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
