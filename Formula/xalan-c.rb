class XalanC < Formula
  desc "XSLT processor"
  homepage "https://apache.github.io/xalan-c/"
  url "https://www.apache.org/dyn/closer.lua?path=xalan/xalan-c/sources/xalan_c-1.12.tar.gz"
  mirror "https://archive.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.12.tar.gz"
  sha256 "ee7d4b0b08c5676f5e586c7154d94a5b32b299ac3cbb946e24c4375a25552da7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "26f8a177f0c16a0a9fb184683a37e0a7bc9b7ca44c6b71a4537aa0893afd59bf"
    sha256 cellar: :any,                 arm64_monterey: "7c3a09c8295eee985ae29bbb413117f3bcf561c2fb12ac2cf694812a0552a402"
    sha256 cellar: :any,                 arm64_big_sur:  "68fa397917ca7521f087e321c3f2c5201fd4692bdc61c7f807386ccfa2080486"
    sha256 cellar: :any,                 ventura:        "d557fdf82ac5902c9943ce23b18e30584bbb97679c2d139c1ac3170d7e7f15aa"
    sha256 cellar: :any,                 monterey:       "3e45d82c41f1a30500ef0f9cc3614cae511ff88d9d25b4e041071d99ef2b364c"
    sha256 cellar: :any,                 big_sur:        "0fcb0a2509617e2b58bc75dd931a64ef065c4081e91066d05bae1f719cec6a81"
    sha256 cellar: :any,                 catalina:       "becbc6b53dc6656b58e9543832640fac7b4dacee131f2f830d918045b8c82f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809520d5fb3e9f89472b262c52884303ee41b8e4cf845a36783c042419882c85"
  end

  # https://marc.info/?l=xalan-dev&m=166603389016762&w=2
  deprecate! date: "2022-10-22", because: :deprecated_upstream

  depends_on "cmake" => :build
  depends_on "xerces-c"

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build",
                    "-Dtranscoder=default",
                    "-Dmessage-loader=inmemory",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Clean up links
    rm Dir["#{lib}/*.dylib.*"]
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
