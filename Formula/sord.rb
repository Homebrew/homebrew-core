class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.6.tar.bz2"
  sha256 "667af27a76085336d3865d087c1bb31a9d5f85b3359bcb27112dc43659229d44"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+.\d+.\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "562bf3b82c66478cbba9ce9ff756eb589ed67e5cef69959011e5f0f74b21dacc" => :catalina
    sha256 "0514a9d6b801a3b0b7ec76c4bf352a69e4efc161442a083176774b8ebe915d84" => :mojave
    sha256 "1c3a4a21431fe39b06fdd8d4b5fdb80b176f0e4fe1697a85c6ead498d342f0ab" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
