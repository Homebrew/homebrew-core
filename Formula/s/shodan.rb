class Shodan < Formula
  include Language::Python::Virtualenv

  desc "Python library and command-line utility for Shodan"
  homepage "https://cli.shodan.io"
  url "https://files.pythonhosted.org/packages/db/14/2e16620742e5d56eb6035c0bbf16ae04a8dee50d67d09d8df4e196d53184/shodan-1.30.0.tar.gz"
  sha256 "c9617c66c47b87d4801e7080b6c769ec9a31da398defe0b047a6794927436453"
  license "MIT"
  head "https://github.com/achillean/shodan-python.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d23152b79f7e15423df02fc752dd27f08f0fec3e56748bd5b7bfb046f171197"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c00759645646e941ae68162fb790ebf0e5218e221676319e54a7ad56f0e7ca87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95219748f36d74a1bacd0a261a11bd342a77f39429451e8d40a8f756ebf10988"
    sha256 cellar: :any_skip_relocation, ventura:        "69cf05452061383a55b6acb2af77e1b01c583039b951d53a9c7149795cc29e21"
    sha256 cellar: :any_skip_relocation, monterey:       "fd683642dc5b1b3b1869bb99f8317ff88dd346d77e412fada69d5ad0f1804f1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4b33f527e705e2881bef2c526bc7a8155906a21cb5cb92e8c5cfa1913736907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcced46ba43d54f9c9559b055ba559f0753c4cbacd7eb48d73ff4edf6ebc2da7"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/80/90/d294a3f69b4143cf56c326064086236bc8157c389497893d940968e6cda2/tldextract-3.4.4.tar.gz"
    sha256 "5fe3210c577463545191d45ad522d3d5e78d55218ce97215e82004dcae1e1234"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "xlsxwriter" do
    url "https://files.pythonhosted.org/packages/04/d4/3cc6a3cd112a91d95f554ca8909c8528addf06d79c51ccd40e39a6ff48e1/XlsxWriter-3.1.2.tar.gz"
    sha256 "78751099a770273f1c98b8d6643351f68f98ae8e6acf9d09d37dc6798f8cd3de"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shodan version")

    output = shell_output("#{bin}/shodan init 2>&1", 2)
    assert_match "Error: Missing argument '<api key>'.", output
  end
end
