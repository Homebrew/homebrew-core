class Visidata < Formula
  include Language::Python::Virtualenv

  desc "Terminal spreadsheet multitool for discovering and arranging data"
  homepage "https://www.visidata.org/"
  url "https://files.pythonhosted.org/packages/6c/41/b026336b7075a2c8461c1ba0dfffd456902f736722f4a016f21fee1e6d7c/visidata-3.1.1.tar.gz"
  sha256 "8c4484158f0851e4887e595542bd65bdd991de9c20652b442b3fd9742ce8b031"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c59340511e66537da6a9d30fc32913ab638cde115e0f9ebcf39c3a60e9251734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59340511e66537da6a9d30fc32913ab638cde115e0f9ebcf39c3a60e9251734"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c59340511e66537da6a9d30fc32913ab638cde115e0f9ebcf39c3a60e9251734"
    sha256 cellar: :any_skip_relocation, sonoma:        "386ca2b4afbaf1f0e79ee848379fd2d11b023134dcb58e2dd95d259e62b02706"
    sha256 cellar: :any_skip_relocation, ventura:       "386ca2b4afbaf1f0e79ee848379fd2d11b023134dcb58e2dd95d259e62b02706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c7de494b7a6b175f136c3b3bfc99a7eeb57b5cedd8be75f87f8df1c44004db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59340511e66537da6a9d30fc32913ab638cde115e0f9ebcf39c3a60e9251734"
  end

  depends_on "python@3.13"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/08/c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6e/importlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    man1.install "visidata/man/visidata.1", "visidata/man/vd.1"
  end

  test do
    %w[vd visidata].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,42
      Bob,34
    CSV

    assert_match "age", shell_output("#{bin}/vd -b -f csv test.csv")
  end
end
