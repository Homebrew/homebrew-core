class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.10.tar.bz2"
  sha256 "affa80deec78921f86335e6fc3f18b80aefecf424f6a5755e9f2fa0eb0710edf"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "d1bcd61616acf402f9c9d5ba7e45430d7c680907b1ae40e1619abeb6d032ecf5"
    sha256 cellar: :any,                 arm64_big_sur:  "820e665f024fc4cadc9bdc1dbbed043ff8532b78820bd562111ad58fe7b7c773"
    sha256 cellar: :any,                 monterey:       "a4c365f5e3f5684668223f58ff83f51b59931fca800eea1883debbad006454e4"
    sha256 cellar: :any,                 big_sur:        "88b931157faf0b6aee0574b3643a0050cb4bfe457ca8afbd7349d7d44bf69927"
    sha256 cellar: :any,                 catalina:       "bf3e88a5e10d6f553c16961289a1ab8eae961f9f025ad62b09c2469b9a87529b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b4777b706dce7681061463bfc96c3040ef6b874fcac9511173c50c03818a59"
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
