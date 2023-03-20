class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/de/ff/196ca63becc5faf5586202ab6e30102322adeea538bb45549d97ed38225d/vulture-2.7.tar.gz"
  sha256 "67fb80a014ed9fdb599dd44bb96cb54311032a104106fc2e706ef7a6dad88032"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5dfb1c1062bb14adee775412b7abbef11b38c630a3d80487c4f1ae6c78c152"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db8de365af3d73df7f7de4ac62175d676949f4ba895d7e4762fd897997a0f3bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76dc4f359ec6f15a3aafc86bbb17dcc1bf8847ae9b0d24fcd9ca4078d99004d6"
    sha256 cellar: :any_skip_relocation, ventura:        "abf242b7c8b219f3c022173298de96be0cdbc9a7cab581623e0e676a1d4b4286"
    sha256 cellar: :any_skip_relocation, monterey:       "69059507d049b8b05f9e84690d4b2f448946b299ffb62746662daf98628e53b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efd3717512cb9dcf74601f148400fd427a8e27cd308677b8b4c864011d3e442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832b6778a2859b8f5dc40a1edcca62fe0b0605c7018f8d7925e64d3d459cbc5b"
  end

  depends_on "python@3.11"

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")
    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 1)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
