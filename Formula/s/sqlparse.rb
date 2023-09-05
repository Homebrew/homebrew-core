class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
  sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "084a2b2ad8c942fe98a7dfea12cdeda157b17a5e6439969e216565149cbf37a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c4098779ea36edae5857bf130c0f4836bcfe1efb36d3e83e70f8974403e8ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8edad2fd0327cb6d3b25b6bbf38558a3c4a4802dc5347da50e60de26f9c84970"
    sha256 cellar: :any_skip_relocation, ventura:        "ae738b6902ac2ae44ff3ab0bee457298063bf5d5967c437a9604efac0002a010"
    sha256 cellar: :any_skip_relocation, monterey:       "8fa4b52033e8c4a8f4a879a51846afc8676c7267c0893634e4de2830b6144cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c6f73bb218836ebbdb651c4ef436743818b99303a42bbca54d31409e5033116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4b5b97c59bfd1dc543b12cb6ed23b98feb5ec991e824ad442c171dc8a04103"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
