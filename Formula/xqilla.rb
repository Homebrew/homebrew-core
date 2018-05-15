class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.4.tar.gz"
  sha256 "adfd4df011fcda08be3f51771006da23e852bac81e2fe63159beddc3633b3f55"

  bottle do
    cellar :any
    sha256 "dd50c76bcc99f8dd8d2ceb62a7e8379198e0a5e6986c233bca1a935aa34223d3" => :high_sierra
    sha256 "d2120862cf3ad0dda28c6c90589f87c49b98376b543f3c0fd1aa1446282a7194" => :sierra
    sha256 "23b0237d4a917ac6e91d4d1957f676e466b3e218d2abffb671503d982f827a83" => :el_capitan
  end

  depends_on "xerces-c"

  conflicts_with "zorba", :because => "Both supply xqc.h"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-xerces=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <xqilla/xqilla-simple.hpp>

      int main(int argc, char *argv[]) {
        XQilla xqilla;
        AutoDelete<XQQuery> query(xqilla.parse(X("1 to 100")));
        AutoDelete<DynamicContext> context(query->createDynamicContext());
        Result result = query->execute(context);
        Item::Ptr item;
        while(item == result->next(context)) {
          std::cout << UTF8(item->asString(context)) << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lxqilla",
           "-I#{Formula["xerces-c"].opt_include}",
           "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c",
           testpath/"test.cpp", "-o", testpath/"test"
    system testpath/"test"
  end
end
