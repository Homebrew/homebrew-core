class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.12.tar.bz2"
  sha256 "9f9dab4125d88256c1f694b6638cbdbf84c15ce31003cd83cb32fb2192d3e866"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be91ffb01eaed7dab3bede32474483b0d26a780ad6565cbcc95cc7ba2a80ed18"
    sha256 cellar: :any,                 arm64_big_sur:  "b4c08728be51e411bcf7cbff886aae172924b90113a1fcc59258b40a136c61c1"
    sha256 cellar: :any,                 monterey:       "a4af1b773a7587ecca6af264818338371a85679c847c8e218e7d033adef89b8d"
    sha256 cellar: :any,                 big_sur:        "45c665a31d0d956d94422ea25913d78e675165b43d738dfc3dc61e2863817b7f"
    sha256 cellar: :any,                 catalina:       "78bf88ae66292c26c07192afb911cad5055d054ce4e8f306bed86a63e9eb1e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb299d5b99d16463f8104eb2b8df075982afd42ea57f4f3d13fdc23b37d0a71"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    rdf_syntax_ns = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    re = %r{(<#{Regexp.quote(rdf_syntax_ns)}#.*>\s+)?<http://example.org/List>\s+\.}
    assert_match re, pipe_output("serdi -", "() a <http://example.org/List> .")
  end
end
