class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/0e/80/dc4215b549ddbe1d1251bc4cd47ad6f4a65e1f9803815997817ff297d22e/txt2tags-3.7.tar.gz"
  sha256 "27969387206d12b4e4a0eb13d0d5dd957d71dbb932451b0dceeab5e3dbb6178a"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5417013a87fca45121b25df471e050f12d611fcab11594ee5b442543eff2c457" => :catalina
    sha256 "894d7e9c49720ccf3a0c27f0d8c9e46297dd6cbb27f0efbddf41daf5dffbe230" => :mojave
    sha256 "8aa1a28a1d6697d6b247e360afd13079635404805d31ff9b83afaab9bb23a0b3" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
