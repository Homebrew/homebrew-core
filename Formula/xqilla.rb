class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.3.tar.gz"
  sha256 "8f76b9b4f966f315acc2a8e104e426d8a76ba4ea3441b0ecfdd1e39195674fd6"
  revision 1

  bottle do
    cellar :any
    sha256 "dd50c76bcc99f8dd8d2ceb62a7e8379198e0a5e6986c233bca1a935aa34223d3" => :high_sierra
    sha256 "d2120862cf3ad0dda28c6c90589f87c49b98376b543f3c0fd1aa1446282a7194" => :sierra
    sha256 "23b0237d4a917ac6e91d4d1957f676e466b3e218d2abffb671503d982f827a83" => :el_capitan
  end

  depends_on "xerces-c"

  conflicts_with "zorba", :because => "Both supply xqc.h"

  needs :cxx11

  # See https://sourceforge.net/p/xqilla/bugs/48/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xqilla/xerces-containing-node.patch"
    sha256 "36ffb2dff579e5610ca3be2a962942433127b24a78ca454647059d6d54b8e014"
  end

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
