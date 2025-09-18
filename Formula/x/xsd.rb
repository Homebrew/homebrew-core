class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "https://www.codesynthesis.com/products/xsd/"
  url "https://www.codesynthesis.com/download/xsd/4.2/xsd-4.2.0.tar.gz"
  sha256 "2bed17c601cfb984f9a7501fd5c672f4f18eac678f5bdef6016971966add9145"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://www.codesynthesis.com/products/xsd/download.xhtml"
    regex(/href=.*?xsd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9beb0bcaa0a49b5de1613b0ce1424a3f1ba33d0697860103c4a93ec4b7f4e748"
    sha256 cellar: :any,                 arm64_sequoia: "9bab1b8a054ae9b32e68d6c0ab9ee59435715bcedbdc1206de8b54a5c8210ce5"
    sha256 cellar: :any,                 arm64_sonoma:  "b095172797b397ec3afe2c05033aa138ef2449d982aa8e77b9b26b484cd7fbc9"
    sha256 cellar: :any,                 arm64_ventura: "515effcddd5163ba8ac3fc30f2daf51d5c9380209b376cd4fbbffc54eb823b9e"
    sha256 cellar: :any,                 sonoma:        "dcd70b1bada26e56ead16eaceeced482d7e8c4b84a8894d34073d46ad0c2f57e"
    sha256 cellar: :any,                 ventura:       "d6d34d7402ae33a991c7817a34d6f8bdec2f55bc68ec922b5e112d639f308dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b203c546a627a452e99687209c707b56a69334aa9dd509bcf80f2e9e2e0c055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ce6cba3e04b1e0239789b2c57ab98fbf8b465dc8477fb43c184da992002322"
  end

  depends_on "build2" => :build
  depends_on "libcutl"
  depends_on "libxsd-frontend"
  depends_on "xerces-c"

  conflicts_with "mono", because: "both install `xsd` binaries"

  resource "libxsd" do
    url "https://www.codesynthesis.com/download/xsd/4.2/libxsd-4.2.0.tar.gz"
    sha256 "55caf0038603883eb39ac4caeaacda23a09cf81cffc8eb55a854b6b06ef2c52e"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "`libxsd` resource needs to be updated!" if version != resource("libxsd").version

    system "b", "configure", "config.cc.loptions=-L#{HOMEBREW_PREFIX}/lib", "config.install.root=#{prefix}"
    system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"

    resource("libxsd").stage do
      system "b", "configure", "config.install.root=#{prefix}"
      system "b", "install", "--jobs=#{ENV.make_jobs}", "-V"
    end
  end

  test do
    (testpath/"meaningoflife.xsd").write <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
        <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    XSD

    (testpath/"meaningoflife.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <MeaningOfLife xmlns="https://brew.sh/XSDTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xsi:schemaLocation="https://brew.sh/XSDTest meaningoflife.xsd">
        42
      </MeaningOfLife>
    XML

    (testpath/"xsdtest.cxx").write <<~CPP
      #include <cassert>
      #include "meaningoflife.hxx"
      int main (int argc, char *argv[]) {
        assert(2==argc);
        std::unique_ptr<::xml_schema::positive_integer> x = XSDTest::MeaningOfLife(argv[1]);
        assert(42==*x);
        return 0;
      }
    CPP

    system bin/"xsd", "cxx-tree", "meaningoflife.xsd"
    assert_path_exists testpath/"meaningoflife.hxx"
    assert_path_exists testpath/"meaningoflife.cxx"

    system ENV.cxx, "-std=c++11", "xsdtest.cxx", "meaningoflife.cxx", "-o", "xsdtest",
                    "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    system "./xsdtest", "meaningoflife.xml"
  end
end
