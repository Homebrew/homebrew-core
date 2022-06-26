class Wllvm < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for building whole-program LLVM bitcode files"
  homepage "https://pypi.org/project/wllvm/"
  url "https://files.pythonhosted.org/packages/4b/df/31d7519052bc21d0e9771e9a6540d6310bfb13bae7dacde060d8f647b8d3/wllvm-1.3.1.tar.gz"
  sha256 "3e057a575f05c9ecc8669a8c4046f2bfdf0c69533b87b4fbfcabe0df230cc331"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "658e5b083456506153ed16be765b47296542dc80889fb1d4ab99b1ed46979e19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c20248474947e050b8e5c8950301896c7343beca3baa4063a910c68e44f59cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "1f5146c3f4eb527d865e739ff990436d0c23dd35551a111633f70286c51974ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "946b4f71c813838a6bcf71992379dbc092fe1586374c8b372f70a5a9f007a4fd"
    sha256 cellar: :any_skip_relocation, catalina:       "946b4f71c813838a6bcf71992379dbc092fe1586374c8b372f70a5a9f007a4fd"
    sha256 cellar: :any_skip_relocation, mojave:         "d371b3aeaae37cdb1f250e536aaa6f52dd0da4e132bdddb02a238a702d130735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f8b627879dd34512b6423047ec04d5b668ac28dbde974c2e7df85ddb703a6b"
  end

  depends_on "llvm" => :test
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin
    (testpath/"test.c").write "int main() { return 0; }"

    with_env(LLVM_COMPILER: "clang") do
      system bin/"wllvm", testpath/"test.c", "-o", testpath/"test"
    end
    assert_predicate testpath/".test.o", :exist?
    assert_predicate testpath/".test.o.bc", :exist?

    system bin/"extract-bc", testpath/"test"
    assert_predicate testpath/"test.bc", :exist?
  end
end
