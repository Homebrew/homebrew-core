class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "https://www.codesynthesis.com/products/xsd/"
  url "https://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2"
  version "4.0.0"
  sha256 "eca52a9c8f52cdbe2ae4e364e4a909503493a0d51ea388fc6c9734565a859817"
  revision 1

  bottle do
    cellar :any
    sha256 "8de0a3cfd410a3b2640a557e009b751f67c6f2416e38e42aa3a6634e73941847" => :catalina
    sha256 "cb064aa81b48f1777f14888e4c6df4ae3782159f5a315944df49882bce06b231" => :mojave
    sha256 "25dfd3dbcbe7f6f442bf6d45adaa849b5fbc4e7360ca4d9084bb1910252f992d" => :high_sierra
    sha256 "935d1bcd6d9cf35cdd42e68ddb9931ad29df0834b76d6f4b9cdaa743176d7bae" => :sierra
    sha256 "4e4a26fc0a99b11e8a740b6f5041964b682048de7ff0a9cbfd15ffea263f0c62" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"

  conflicts_with "mono", :because => "both install `xsd` binaries"

  # Patches:
  # 1. As of version 4.0.0, Clang fails to compile if the <iostream> header is
  #    not explicitly included. The developers are aware of this problem, see:
  #    https://www.codesynthesis.com/pipermail/xsd-users/2015-February/004522.html
  # 2. As of version 4.0.0, building fails because this makefile invokes find
  #    with action -printf, which GNU find supports but BSD find does not. There
  #    is no place to file a bug report upstream other than the xsd-users mailing
  #    list (xsd-users@codesynthesis.com). I have sent this patch there but have
  #    received no response (yet).
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/xsd/4.0.0.patch"
    sha256 "55a15b7a16404e659060cc2487f198a76d96da7ec74e2c0fac9e38f24b151fa7"
  end

  def install
    ENV.append "LDFLAGS", `pkg-config --libs --static xerces-c`.chomp
    ENV.cxx11
    system "make", "install", "install_prefix=#{prefix}"
  end

  test do
    schema = testpath/"meaningoflife.xsd"
    schema.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
          <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    EOS
    instance = testpath/"meaningoflife.xml"
    instance.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <MeaningOfLife xmlns="https://brew.sh/XSDTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="https://brew.sh/XSDTest meaningoflife.xsd">
          42
      </MeaningOfLife>
    EOS
    xsdtest = testpath/"xsdtest.cxx"
    xsdtest.write <<~EOS
      #include <cassert>
      #include "meaningoflife.hxx"
      int main (int argc, char *argv[]) {
          assert(2==argc);
          std::auto_ptr< ::xml_schema::positive_integer> x = XSDTest::MeaningOfLife(argv[1]);
          assert(42==*x);
          return 0;
      }
    EOS
    system "#{bin}/xsd", "cxx-tree", schema
    assert_predicate testpath/"meaningoflife.hxx", :exist?
    assert_predicate testpath/"meaningoflife.cxx", :exist?
    system "c++", "-o", "xsdtest", "xsdtest.cxx", "meaningoflife.cxx",
                  "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    assert_predicate testpath/"xsdtest", :exist?
    system testpath/"xsdtest", instance
  end
end
