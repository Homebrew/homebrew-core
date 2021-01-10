class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.8.tar.bz2"
  sha256 "7c289d2eaabf82fa6ac219107ce632d704672dcfb966e1a7ff0bbc4ce93f5e14"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?sord[._-]v?(\d+.\d+.\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "433edf9d995a14aecec761f3e4a10e2ce18aced3cd250718f7de1742628e1c27" => :big_sur
    sha256 "999bfbc2e98af85478f5ec8c45f78ed0e089227382b702327a65c55d9717f81a" => :arm64_big_sur
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
