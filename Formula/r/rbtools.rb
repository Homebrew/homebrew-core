class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/5b/fc/51d1604226036ed182ede25e5cc84d1bb9f583d15b88315108bbbcafb23f/rbtools-7.0.tar.gz"
  sha256 "2e02491f07181a0a1d8faf2bf9f8c7e89eb73fe5ec59a0f7859e1e0bfb4cbf33"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8b9467f78945b6f4008ad5689fec576a5b5548269c29a1d2075185d482e6b699"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "housekeeping" do
    url "https://files.pythonhosted.org/packages/a7/56/2e66e26b44f3970d9d6aed1ab1b5dce8a741bc7f0c2918f222831e130c5a/housekeeping-1.1.tar.gz"
    sha256 "75e71f1cc501885406f6be81410c9b05361871a3ecccde3891336da1e92426b5"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/6f/7e/1e7e8dc30634b93ebb3d58a3dea569ad146e656218d3960ab04f62047b29/importlib_metadata-9.0.1.tar.gz"
    sha256 "ab830580bc0ef3db61ce8fae716389e5462b67e033018bab6d8f80ef17172f99"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/e4/06/b56dfa750b44e86157093bc8fca0ab81dccbf5260510de4eaf1cb69b5b99/importlib_resources-7.1.0.tar.gz"
    sha256 "0722d4c6212489c530f2a145a34c0a7a3b4721bc96a15fada5930e2a0b760708"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"

    # Workaround needing six pre-installed
    # Backport of https://github.com/beanbaginc/diffx/commit/658bf85d0cf1a96671fc04fe3afb48b035f348a4
    patch :DATA
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typelets" do
    url "https://files.pythonhosted.org/packages/a2/c6/7df6df552fab0e6ddad9d230981afb9deaa662211756cdf2bf70aa091ba1/typelets-1.1.tar.gz"
    sha256 "5fd0a01016402a2f87892ac855241ee2769b7595c7e955acce040c86f71bfb38"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/dc/23/655a1802fe8041302c959774ca7c80b53bc24737ff3ef45cb50ef11bd96c/zipp-4.1.1.tar.gz"
    sha256 "7ebb7a44c021b29fd8dbd7cce6812d0d7b5b454521f93cc71af6ccd155aaa70b"
  end

  def install
    venv = virtualenv_install_with_resources

    bash_completion.install "rbtools/commands/conf/completions/bash" => "rbt"
    zsh_completion.install "rbtools/commands/conf/completions/zsh" => "_rbt"

    # Remove tests to make :all bottle
    rm_r venv.site_packages/"rbtools/clients/tests"
  end

  test do
    system "git", "init"
    system bin/"rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    assert_match "Cleared cache in", shell_output("#{bin}/rbt clear-cache")
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
