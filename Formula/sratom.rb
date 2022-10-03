class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom.html"
  url "https://download.drobilla.net/sratom-0.6.14.tar.xz"
  sha256 "9982faf40db83aedd9b3850e499fecd6852b8b4ba6dede514013655cffaca1e6"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "05e228669eec5974a627b10a8629f805629ebfc5d587f060902831f3f4be7316"
    sha256 cellar: :any, arm64_big_sur:  "8b4d423579e613d1ae97f2e3451fece7391941c7ad24e1c586be8d5e9cf9e5f9"
    sha256 cellar: :any, monterey:       "83f4f118688d3fa0f844efd4619b28c43a6d43c6bb068fe7d09494f3146bfed7"
    sha256 cellar: :any, big_sur:        "043c402fa73d4ea35d504443499881714d35cf135fb5395037708b7950d6b8da"
    sha256 cellar: :any, catalina:       "3d8f94ffc2361105af3f044c9d01874e2395f46ac8bbb36e30622b5bcab0c7e7"
    sha256               x86_64_linux:   "7b5c0f85be3dc1fcd4a4f2c7ce1d32a1bae97eea8e11b735364e1d30b05de92a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dtests=disabled", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    serd = Formula["serd"].opt_include
    sord = Formula["sord"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{serd}/serd-0", "-I#{sord}/sord-0", "-I#{include}/sratom-0",
                   "-L#{lib}", "-lsratom-0", "test.c", "-o", "test"
    system "./test"
  end
end
