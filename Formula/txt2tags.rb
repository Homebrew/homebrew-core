class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/0e/80/dc4215b549ddbe1d1251bc4cd47ad6f4a65e1f9803815997817ff297d22e/txt2tags-3.7.tar.gz"
  sha256 "27969387206d12b4e4a0eb13d0d5dd957d71dbb932451b0dceeab5e3dbb6178a"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7ada1460b8414d186474f786fe2a5d2643b4f08cca60e3b81c9c946fa308cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ada1460b8414d186474f786fe2a5d2643b4f08cca60e3b81c9c946fa308cbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ada1460b8414d186474f786fe2a5d2643b4f08cca60e3b81c9c946fa308cbe"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7145ac3dc3b49ff98088c5201a961bf361dc2cabb35b5bbb6db533fc861e82"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd7145ac3dc3b49ff98088c5201a961bf361dc2cabb35b5bbb6db533fc861e82"
    sha256 cellar: :any_skip_relocation, catalina:       "fd7145ac3dc3b49ff98088c5201a961bf361dc2cabb35b5bbb6db533fc861e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5e182914b9b55783f347caeaa9d5f671e49bb1bbd055eb2c75958e110226f7"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
