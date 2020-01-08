class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.4.tar.bz2"
  sha256 "b15998f4e7ad958201346009477d6696e90ee5d3e9aff25e7e9be074372690d7"

  bottle do
    cellar :any
    sha256 "8c1546cb6310b54955a6c0e4aa8a7a64a989ee4917bd299da9abf7bb8837461b" => :catalina
    sha256 "3e7948f1de2a394508f2c8c8a251eb5aacc72ff81d3c226e0a6ef886989baa0e" => :mojave
    sha256 "05c4c8862795925b5135e57a6bb2e3a532b1a462a1832273eab15dc09459698e" => :high_sierra
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
