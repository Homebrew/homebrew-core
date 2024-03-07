class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/27/17/c9cdebfc86e824e25592a20a8871225dad61b6b6c0101f4a2cb3434890dd/txt2tags-3.9.tar.gz"
  sha256 "7e4244db6a63aaa58fc17fa4cdec62b6fb89cc41d3a00ba4edaffa37f27d6746"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f9f591d57949313b15595aa632c72e5596b2f2a95c4b6b1022c9b299aeed78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "035e98edb3c676e1b1d26c5cc574a005053e05cda0da7f03d8e883c21aab28c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9d0c6eeb44c42c0f81b484e1a06dfe53b0d8450d70e884de3ac322cb2bcedf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5c30ace29d07c134fe9c1b48202bcc64adadb35108457a5a53b7721f126612d"
    sha256 cellar: :any_skip_relocation, ventura:        "57a19096879160bc84269c6144b6b151fe8c3e40cd0faeb3673d7e925bf8bf1f"
    sha256 cellar: :any_skip_relocation, monterey:       "4b821b3b365e54f66e5df3c9843735ededf5f497bc336734dff54bf60627d20d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a075f97bedb110cc7d271e98fbf7deb3ebd315bd358b7e2b20570014559f9dd9"
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
