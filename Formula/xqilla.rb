class Xqilla < Formula
  desc "XQuery and XPath 2 command-line interpreter"
  homepage "https://xqilla.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xqilla/XQilla-2.3.3.tar.gz"
  sha256 "8f76b9b4f966f315acc2a8e104e426d8a76ba4ea3441b0ecfdd1e39195674fd6"
  revision 1

  bottle do
    cellar :any
    sha256 "c0b84fd4cbdc2b531994ef9a677fbeae765446f038391c6e30c8d2b56af07a4d" => :high_sierra
    sha256 "ec371fc2b757a643eaf9a2ba738ac26038f848abc5ff84cdba67e192c8e69ccd" => :sierra
    sha256 "50c54dbee37fb8def85096c322d8c2e48e01e568aca9d47936b5e2c25c19c0f6" => :el_capitan
    sha256 "7b0530e7eb211b6789d26a1331f7a8402ea83351587fb24686284dd6938a8362" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
