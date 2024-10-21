class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "https://www.codesynthesis.com/products/xsd/"
  url "https://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2"
  version "4.0.0"
  sha256 "eca52a9c8f52cdbe2ae4e364e4a909503493a0d51ea388fc6c9734565a859817"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }
  revision 2

  livecheck do
    url "https://www.codesynthesis.com/products/xsd/download.xhtml"
    regex(/href=.*?xsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8119ae88416a48f44f45d39b54d6c14b8849bae8fed840a0e88456c7c2bff144"
    sha256 cellar: :any,                 arm64_sonoma:  "a36a30cf1bdff08460969ddcc24fae52a5cc743d57253c564d4d89a828f4db64"
    sha256 cellar: :any,                 arm64_ventura: "4f2eb34d577abf123990d70c6ee5ff4b8d77e53778260f4b93325f68941d3e33"
    sha256 cellar: :any,                 sonoma:        "a0154c4c947ed3117bc4c45530a90a4ff2ac6c9d748472371b955119dfac9363"
    sha256 cellar: :any,                 ventura:       "5f941b47bc3bbd36bd6282e3d580f123056768597b66397e308e7aac5b991b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1617579f8c28bfe87fcb4a1630a34700bcf0266bb4a179969e49fcc62fde4eed"
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"

  conflicts_with "mono", because: "both install `xsd` binaries"

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
    # Rename version files so that the C++ preprocess doesn't try to include these as headers.
    mv "xsd/version", "xsd/version.txt"
    mv "libxsd-frontend/version", "libxsd-frontend/version.txt"
    mv "libcutl/version", "libcutl/version.txt"

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
    system bin/"xsd", "cxx-tree", schema
    assert_predicate testpath/"meaningoflife.hxx", :exist?
    assert_predicate testpath/"meaningoflife.cxx", :exist?
    system ENV.cxx, "-o", "xsdtest", "xsdtest.cxx", "meaningoflife.cxx", "-std=c++11",
                  "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    assert_predicate testpath/"xsdtest", :exist?
    system testpath/"xsdtest", instance
  end
end
