class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/47/20/112a54002d2023b249906508feefeebcce7d73a25618f3f1f76c7673734d/RBTools-5.0.tar.gz"
  sha256 "beb373100d0f2d707370a6ce449b6f98110dd0081accffd766d955cea16f08bc"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8c47b99c3dffa17933154d063bb26b3fd6e6d68f030dc8fd34565a1b5b1debd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c47b99c3dffa17933154d063bb26b3fd6e6d68f030dc8fd34565a1b5b1debd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c47b99c3dffa17933154d063bb26b3fd6e6d68f030dc8fd34565a1b5b1debd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b72af757a32f5971f1eed8c2cd00fdd43ec687261e009ff32e88d49b46badc89"
    sha256 cellar: :any_skip_relocation, ventura:        "b72af757a32f5971f1eed8c2cd00fdd43ec687261e009ff32e88d49b46badc89"
    sha256 cellar: :any_skip_relocation, monterey:       "b72af757a32f5971f1eed8c2cd00fdd43ec687261e009ff32e88d49b46badc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce62926ea87ef44675804fbc21dbbc0e2494f9581a47bc463eb64b1dbc63c91c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "housekeeping" do
    url "https://files.pythonhosted.org/packages/a7/56/2e66e26b44f3970d9d6aed1ab1b5dce8a741bc7f0c2918f222831e130c5a/housekeeping-1.1.tar.gz"
    sha256 "75e71f1cc501885406f6be81410c9b05361871a3ecccde3891336da1e92426b5"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/c8/9d/6ee73859d6be81c6ea7ebac89655e92740296419bd37e5c8abdb5b62fd55/importlib_resources-6.4.0.tar.gz"
    sha256 "cdb2b453b8046ca4e3798eb1d84f3cce1446a0e8e7b5ef4efb600f19fc398145"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"

    # upstream patch ref, https://github.com/beanbaginc/diffx/pull/2
    patch :DATA
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/5a/c0/b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2/tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e8/fb/4217a963512b9646274fe4ce0aebc8ebff09bbb86c458c6163846bb65d9d/typing_extensions-4.12.1.tar.gz"
    sha256 "915f5e35ff76f56588223f15fdd5938f9a1cf9195c0de25130c627e4d597f6d1"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d3/20/b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1/zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    # Work around pydiffx needing six pre-installed
    # Upstream PR: https://github.com/beanbaginc/diffx/pull/2
    virtualenv_install_with_resources end_with: "pydiffx"

    bash_completion.install "rbtools/commands/conf/completions/bash" => "rbt"
    zsh_completion.install "rbtools/commands/conf/completions/zsh" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end

__END__
diff --git a/setup.py b/setup.py
index ed91128..860ef81 100755
--- a/setup.py
+++ b/setup.py
@@ -8,10 +8,9 @@ import sys

 from setuptools import setup, find_packages

-from pydiffx import get_package_version
-

 PACKAGE_NAME = 'pydiffx'
+version = '1.1'

 # NOTE: When updating, make sure you update the classifiers below.
 SUPPORTED_PYVERS = ['2.7', '3.6', '3.7', '3.8', '3.9', '3.10', '3.11']
@@ -36,7 +35,7 @@ with open('README.rst', 'r') as fp:


 setup(name=PACKAGE_NAME,
-      version=get_package_version(),
+      version=version,
       license='MIT',
       description='Python module for reading and writing DiffX files.',
       long_description=long_description,
@@ -48,7 +47,14 @@ setup(name=PACKAGE_NAME,
       maintainer_email='christian@beanbaginc.com',
       install_requires=[
           'six',
+          'pygments',
       ],
+      extras_require={
+          'test': [
+              'pytest',
+              'kgb ~= 7.1.1'
+          ]
+      },
       entry_points={
           'pygments.lexers': [
               'diffx = pydiffx.integrations.pygments_lexer:DiffXLexer',
