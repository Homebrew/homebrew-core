class Tbox < Formula
  desc "Glib-like multi-platform c library"
  homepage "https://tboox.org/"
  url "https://github.com/waruqi/tbox/archive/v1.6.5.tar.gz"
  sha256 "076599f8699a21934f633f1732977d0df9181891ca982fd23ba172047d2cf4ab"
  head "https://github.com/waruqi/tbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63a75febf95f9f60e187e2100e6d64f772f3ef59d3e2e5603a1fdb7cbe77b992" => :mojave
    sha256 "2f34f5d60397588aff11eefc308a6d23f3a23fe451d118094b04b00024877832" => :high_sierra
    sha256 "956ff755fecde9ad86e5920b9ecd01cf1de767354b60f68476d61a4583c04c81" => :sierra
    sha256 "7b238a754afed5af34b0ccc0caa47b2997791c34ad24b3a403334711e2ec71d4" => :el_capitan
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
