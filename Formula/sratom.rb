class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.6.8.tar.bz2"
  sha256 "3acb32b1adc5a2b7facdade2e0818bcd6c71f23f84a1ebc17815bb7a0d2d02df"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sratom[._-]v?(\d+.\d+.\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "930146db04f23544f9e89c36b783761217e834035e0a6c6d934fc75367852a5d" => :big_sur
    sha256 "3ad5979c9075e82b293802ef25203719e5adf52a720c1c4557171b4ae8648ee8" => :arm64_big_sur
    sha256 "eb959c7930bef09a0d25e5213b387c28d0bcfe5567fe97327699c36ae966d7a9" => :catalina
    sha256 "9a1ae4be9fbf3643fd782aef40928125d257244c368fa7e748df04b5ceb31a1d" => :mojave
    sha256 "acbfea6ae53d91a461eedfe7ad0467be9fe2fe18ae34bb45896efa936b3684ce" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
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
