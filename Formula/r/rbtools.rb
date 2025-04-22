class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/20/04/6e24ad00dd8462f76b291c7c93819e1ce7b883d207627d8e2357bb0c3f3f/rbtools-5.2.tar.gz"
  sha256 "cae223b34b0adba5d53b0eb792560ef144e2ee83fccf657782a67ea42d2111b3"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21603f6a900266621a7e5e2e533250b189d68a00b076c47d9d702697e95a9ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21603f6a900266621a7e5e2e533250b189d68a00b076c47d9d702697e95a9ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21603f6a900266621a7e5e2e533250b189d68a00b076c47d9d702697e95a9ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "08fc4070298e96519307395822744d87bbd616a9e4f5460984ce363d778cb4bf"
    sha256 cellar: :any_skip_relocation, ventura:       "08fc4070298e96519307395822744d87bbd616a9e4f5460984ce363d778cb4bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21603f6a900266621a7e5e2e533250b189d68a00b076c47d9d702697e95a9ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21603f6a900266621a7e5e2e533250b189d68a00b076c47d9d702697e95a9ce0"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "housekeeping" do
    url "https://files.pythonhosted.org/packages/a7/56/2e66e26b44f3970d9d6aed1ab1b5dce8a741bc7f0c2918f222831e130c5a/housekeeping-1.1.tar.gz"
    sha256 "75e71f1cc501885406f6be81410c9b05361871a3ecccde3891336da1e92426b5"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/08/c1395a292bb23fd03bdf572a1357c5a733d3eecbab877641ceacab23db6e/importlib_metadata-8.6.1.tar.gz"
    sha256 "310b41d755445d74569f993ccfc22838295d9fe005425094fad953d7f15c8580"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/09/2d/40599f25667733e41bbc3d7e4c7c36d5e7860874aa5fe9c584e90b34954d/puremagic-1.28.tar.gz"
    sha256 "195893fc129657f611b86b959aab337207d6df7f25372209269ed9e303c1a8c0"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"

    # Workaround needing six pre-installed: https://github.com/beanbaginc/diffx/pull/2
    patch :DATA
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0e/3e/b00a62db91a83fff600de219b6ea9908e6918664899a2d85db222f4fbf19/typing_extensions-4.13.0.tar.gz"
    sha256 "0a4ac55a5820789d87e297727d229866c9650f6521b64206413c4fbada24d95b"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "rbtools/commands/conf/completions/bash" => "rbt"
    zsh_completion.install "rbtools/commands/conf/completions/zsh" => "_rbt"
  end

  test do
    system "git", "init"
    system bin/"rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end

__END__
diff --git a/setup.py b/setup.py
index ed91128..87edbc2 100755
--- a/setup.py
+++ b/setup.py
@@ -8,7 +8,6 @@ import sys
 
 from setuptools import setup, find_packages
 
-from pydiffx import get_package_version
 
 
 PACKAGE_NAME = 'pydiffx'
@@ -36,7 +35,7 @@ with open('README.rst', 'r') as fp:
 
 
 setup(name=PACKAGE_NAME,
-      version=get_package_version(),
+      version='1.1',
       license='MIT',
       description='Python module for reading and writing DiffX files.',
       long_description=long_description,
