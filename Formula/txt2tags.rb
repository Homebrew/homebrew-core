class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/0e/80/dc4215b549ddbe1d1251bc4cd47ad6f4a65e1f9803815997817ff297d22e/txt2tags-3.7.tar.gz"
  sha256 "27969387206d12b4e4a0eb13d0d5dd957d71dbb932451b0dceeab5e3dbb6178a"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d6c3f9115b0b82e14d0dd9cf8647c67004c1432e8c4469c8450950bbe29a3a6b" => :big_sur
    sha256 "0b2ab997932f742fb905ab546a1f12c417d12212f553ecc2be9ddbd49daa3a34" => :arm64_big_sur
    sha256 "6d2516f5a7e3ac9dd0b87f14aa21689c98fc85cd04133d61feb57f7b67ca815e" => :catalina
    sha256 "91d15a499c27c63bcd94c13a348cba21412a3dd2d67630033d0704a4399ca769" => :mojave
    sha256 "2e6484c9e6eacb833e0f1eeac952fa88bf0582c33517d3cba587d8540c0748f2" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
