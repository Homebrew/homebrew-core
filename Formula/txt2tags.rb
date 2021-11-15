class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/0e/80/dc4215b549ddbe1d1251bc4cd47ad6f4a65e1f9803815997817ff297d22e/txt2tags-3.7.tar.gz"
  sha256 "27969387206d12b4e4a0eb13d0d5dd957d71dbb932451b0dceeab5e3dbb6178a"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dfd365914bcf32df61972239ce4e158aa04282f05aefe898b648842b4c37ab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dfd365914bcf32df61972239ce4e158aa04282f05aefe898b648842b4c37ab0"
    sha256 cellar: :any_skip_relocation, monterey:       "2d19d074b099ee8318e3d55f291d6b02de4130a5d643120e03e0dd438c9a6311"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d19d074b099ee8318e3d55f291d6b02de4130a5d643120e03e0dd438c9a6311"
    sha256 cellar: :any_skip_relocation, catalina:       "2d19d074b099ee8318e3d55f291d6b02de4130a5d643120e03e0dd438c9a6311"
    sha256 cellar: :any_skip_relocation, mojave:         "2d19d074b099ee8318e3d55f291d6b02de4130a5d643120e03e0dd438c9a6311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b5979bbd085fa0318c11540cf422e3587a9fca6cd51a4eeb4ef2da98d3b27e"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
