class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/27/17/c9cdebfc86e824e25592a20a8871225dad61b6b6c0101f4a2cb3434890dd/txt2tags-3.9.tar.gz"
  sha256 "7e4244db6a63aaa58fc17fa4cdec62b6fb89cc41d3a00ba4edaffa37f27d6746"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d564f82e975cc5d16fe1c708cb3538b33f2026b8397a9697237db926a14ec32f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ede44bb443145eb0cc57079a40b46525b4d738ec01633c1037acc6ad1a9607c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bbef0cbec995e020cf34df2055d92b518a390c94a6ab2b95beec7333509697a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fa69235bf396e94ca203e004ad35e4be57514ea1f86976aca325d6630703819"
    sha256 cellar: :any_skip_relocation, ventura:        "66492e921efde634568ea7b7e1420bfadee21dee05c3b02d652407d20a0becf2"
    sha256 cellar: :any_skip_relocation, monterey:       "5c9013d055eeb6156945464bf7e40b664a626961ee184e46ee0b8fc1985b1b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffef292683bd6361e4b0370db8b21fe4c9c675bae1f09097b8ff7100d52362e2"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
