class XalanC < Formula
  desc "XSLT processor"
  homepage "https://xalan.apache.org/xalan-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  sha256 "4f5e7f75733d72e30a2165f9fdb9371831cf6ff0d1997b1fb64cdd5dc2126a28"
  revision 1

  bottle do
    cellar :any
    sha256 "24ddfd8ff41dbe54a5570db2a004247f92ef4bc1c897554ea83dfe7c138a172f" => :high_sierra
    sha256 "dfe6413a8d4cba234c105d0936a671a34742d2ac0103db863a644bf78538c28c" => :sierra
    sha256 "0b99ebef6e23b1c0d1e67d4ed8130130ad5c7b6af03f43ea9248c2d78e19a5cc" => :el_capitan
  end

  option "with-docs", "Install HTML docs"

  if build.with? "docs"
    depends_on "doxygen" => :build
    depends_on "graphviz" => :build
  end
  depends_on "xerces-c"

  needs :cxx11

  # Fix segfault. See https://issues.apache.org/jira/browse/XALANC-751
  # Build with char16_t casts.  See https://issues.apache.org/jira/browse/XALANC-773
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xalan-c/xerces-char16.patch"
    sha256 "ebd4ded1f6ee002351e082dee1dcd5887809b94c6263bbe4e8e5599f56774ebf"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xalan-c/locator-system-id.patch"
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
      if build.with? "docs"
        ENV.prepend_path "PATH", "#{buildpath}/c/bin"
        cd "xdocs" do
          # Set the library path in the script which runs Xalan from
          # the source tree, or else the libxalan-c.dylib won't be found.
          # See https://issues.apache.org/jira/browse/XALANC-766
          inreplace "sources/make-xalan.sh", "\"${XALANCMD}\" \\",
                    "export DYLD_FALLBACK_LIBRARY_PATH=#{buildpath}/c/lib:$DYLD_FALLBACK_LIBRARY_PATH\n\"${XALANCMD}\" \\"
          system "./make-apiDocs.sh"
        end
        (share/"doc").install "build/docs/xalan-c"
      end
      # Clean up links
      rm Dir["#{lib}/*.dylib.*"]
    end
  end

  test do
    (testpath/"input.xml").write <<-EOS.undent
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

    (testpath/"transform.xsl").write <<-EOS.undent
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

    assert_match "Article: An XSLT test-case\nAuthors: \n* Roger Leigh\n* Open Microscopy Environment", shell_output("#{bin}/Xalan #{testpath}/input.xml #{testpath}/transform.xsl")
  end
end
