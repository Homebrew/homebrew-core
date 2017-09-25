class XalanC < Formula
  desc "XSLT processor"
  homepage "https://xalan.apache.org/xalan-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  sha256 "4f5e7f75733d72e30a2165f9fdb9371831cf6ff0d1997b1fb64cdd5dc2126a28"
  revision 1

  bottle do
    cellar :any
    sha256 "d6bde41956ece10c148151fae86ec919cd192801a206938ac5f56c697efe0113" => :high_sierra
    sha256 "a10b85fce805d2c002e4df59889759ded2d38f6978f46250f365db91f0ae8397" => :sierra
    sha256 "8de91a28a9e22941818185380825eacd950d1420b850e82879204c4a3a1d3152" => :el_capitan
    sha256 "9af9e5d0c49ca9307ec41f229cb3fb2b53e7f13cc10b0c033750e7512f3dcf1a" => :yosemite
    sha256 "fcfe6027b7d366f6a2bff783e0ab1e9abfc7c38c1a6fd31fa4a2fb9d325a2819" => :mavericks
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
