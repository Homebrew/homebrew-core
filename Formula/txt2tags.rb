class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/0e/80/dc4215b549ddbe1d1251bc4cd47ad6f4a65e1f9803815997817ff297d22e/txt2tags-3.7.tar.gz"
  sha256 "27969387206d12b4e4a0eb13d0d5dd957d71dbb932451b0dceeab5e3dbb6178a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b69cd827273ba735328420541186b42e8092aff82c3f68105f653d858a4d14a9" => :catalina
    sha256 "f346e6c2d9047b392c5e4df4e7503ab10e1a5c3d08316a4a896c7a383c5aec09" => :mojave
    sha256 "b8a627d91e6d267d9c9f58da02d54c6a01f0f3d072e52ab7705623661126e3a8" => :high_sierra
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
