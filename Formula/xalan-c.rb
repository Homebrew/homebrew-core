class XalanC < Formula
  desc "XSLT processor"
  homepage "https://xalan.apache.org/xalan-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  mirror "https://archive.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  sha256 "4f5e7f75733d72e30a2165f9fdb9371831cf6ff0d1997b1fb64cdd5dc2126a28"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 monterey:     "0c1f0cf5ca6206f15e8d2beed36761c3e09b21e78f388e28dbbd38a686d7459a"
    sha256 cellar: :any,                 big_sur:      "13f549b9f924f4729458c3e78bf8c11d15c399aa2d73bccf574b18c2cdb3e110"
    sha256 cellar: :any,                 catalina:     "6a6ac96e65ef391d660c295f6c3a5c349f11cfa0604a6d5111bc88fd0a017304"
    sha256 cellar: :any,                 mojave:       "5b00fab72d4db7db40495ff5331e6cd9539b30f21d6b1357d9dcc2e7275421ae"
    sha256 cellar: :any,                 high_sierra:  "24ddfd8ff41dbe54a5570db2a004247f92ef4bc1c897554ea83dfe7c138a172f"
    sha256 cellar: :any,                 sierra:       "dfe6413a8d4cba234c105d0936a671a34742d2ac0103db863a644bf78538c28c"
    sha256 cellar: :any,                 el_capitan:   "0b99ebef6e23b1c0d1e67d4ed8130130ad5c7b6af03f43ea9248c2d78e19a5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b1190a346ef882ca4c00f05ea0ccb72b1f148347e6200b6ccfed08613267823c"
  end

  depends_on "xerces-c"

  # Fix segfault. See https://issues.apache.org/jira/browse/XALANC-751
  # Build with char16_t casts.  See https://issues.apache.org/jira/browse/XALANC-773
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/71f4b091e4c4939c3fa95981298580a827788e6f/xalan-c/xerces-char16.patch"
    sha256 "ebd4ded1f6ee002351e082dee1dcd5887809b94c6263bbe4e8e5599f56774ebf"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/71f4b091e4c4939c3fa95981298580a827788e6f/xalan-c/locator-system-id.patch"
    sha256 "7c317c6b99cb5fb44da700e954e6b3e8c5eda07bef667f74a42b0099d038d767"
  end

  def install
    ENV.cxx11
    ENV.deparallelize # See https://issues.apache.org/jira/browse/XALANC-696
    ENV["XALANCROOT"] = "#{buildpath}/c"
    ENV["XALAN_LOCALE_SYSTEM"] = "inmem"
    ENV["XALAN_LOCALE"] = "en_US"

    cd "c" do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"

      # Clean up links
      rm Dir["#{lib}/*.dylib.*"]
    end
  end

  test do
    (testpath/"input.xml").write <<~EOS
      <?xml version="1.0"?>
      <Article>
        <Title>An XSLT test-case</Title>
        <Authors>
          <Author>Roger Leigh</Author>
          <Author>Open Microscopy Environment</Author>
        </Authors>
        <Body>This example article is used to verify the functionality
        of Xalan-C++ in applying XSLT transforms to XML documents</Body>
      </Article>
    EOS

    (testpath/"transform.xsl").write <<~EOS
      <?xml version="1.0"?>
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="text"/>
        <xsl:template match="/">Article: <xsl:value-of select="/Article/Title"/>
      Authors: <xsl:apply-templates select="/Article/Authors/Author"/>
      </xsl:template>
        <xsl:template match="Author">
      * <xsl:value-of select="." />
        </xsl:template>
      </xsl:stylesheet>
    EOS

    assert_match "Article: An XSLT test-case\nAuthors: \n* Roger Leigh\n* Open Microscopy Environment",
                 shell_output("#{bin}/Xalan #{testpath}/input.xml #{testpath}/transform.xsl")
  end
end
