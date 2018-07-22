class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.4.tar.gz"
  sha256 "adfd4df011fcda08be3f51771006da23e852bac81e2fe63159beddc3633b3f55"

  bottle do
    cellar :any
    sha256 "44d063c9ae223e0c7fadc62711bbf2b09bd780be2316fac2693ec8da7aff3d92" => :high_sierra
    sha256 "06e5550ca3a1b779ac47209f155af8888183edc2eb97c68ef47bdc70b6e6c0e9" => :sierra
    sha256 "6f106b38d852616826712cdb3e35a61cf4690a8e7cfc120375723a57157a1322" => :el_capitan
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
