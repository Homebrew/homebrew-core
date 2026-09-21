class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/27/17/c9cdebfc86e824e25592a20a8871225dad61b6b6c0101f4a2cb3434890dd/txt2tags-3.9.tar.gz"
  sha256 "7e4244db6a63aaa58fc17fa4cdec62b6fb89cc41d3a00ba4edaffa37f27d6746"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "b938a2bda24749153a44deefd623b6551d5b3349e859dc80c22c18323987f62b"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
