class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "http://www.tboox.org"
  url "https://github.com/waruqi/tbox/archive/v1.6.0.tar.gz"
  sha256 "4f17646eb6623ca4331dc9e7d1163ff6969af58070b7392bab217f194384e0c2"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f6bea8029cc26e9bd92fdd9b2c76bbd2bccb3f0fc3083e6fff31fea44d43e78" => :sierra
    sha256 "1960e9bc4dd0d646c717917ca8307d6d0ddc7b16a490949f01572377e9e2ff26" => :el_capitan
    sha256 "96b482e4e64324bfb4efc8be99f15fd356abb3e499cbd61557e0efb7070eeecf" => :yosemite
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
