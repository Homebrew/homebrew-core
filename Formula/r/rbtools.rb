class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/19/ef/8900501b1af41d2485ee1eabb9f3e309f80fdae911c97927d8917ae99f9f/RBTools-4.1.tar.gz"
  sha256 "24efb20346b905c9be0464e747ee1bdee7967d1b94175697ea0c830d929475ff"
  license "MIT"
  revision 1
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8564b8e193cb9885c8dd7540c947efa679c82979dd980d1990b1bca4761d56af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cf043f16ec3e30fa1a4eab3dc014fe6ba79709517a85c7dd601f46107c3a2a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7588726743915124b0a5ea7a38840beff619907cf06dd990b94722a8923e357"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f443f8e1772f42512672757b7221fae1a42c6f4cd8649dd0b175ec99878fb3"
    sha256 cellar: :any_skip_relocation, ventura:        "10207ac9469ec3585002611a84fcc0a4cfb0f7c9413b796b427ed30cc50c12da"
    sha256 cellar: :any_skip_relocation, monterey:       "66ed002719b9e0caf04e6716c6888bf00bd1cfe8737a2dbf29d90e1f0c281700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ef70330f98a2aac1f43584cf2765555cfcc799b3a315fb0e466bf87971c4716"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
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
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # Work around pydiffx needing six pre-installed
    # Upstream PR: https://github.com/beanbaginc/diffx/pull/2
    pydiffx_resources = %w[setuptools six pydiffx]
    pydiffx_resources.each do |r|
      venv.pip_install(resource(r), build_isolation: false)
    end
    venv.pip_install resources.reject { |r| pydiffx_resources.include? r.name }
    venv.pip_install_and_link buildpath

    bash_completion.install "rbtools/commands/conf/rbt-bash-completion" => "rbt"
    zsh_completion.install "rbtools/commands/conf/_rbt-zsh-completion" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
