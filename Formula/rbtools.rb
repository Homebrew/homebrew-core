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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e625737e34afadf588caec4b2245a49e7d6ec6a169cda2b1afe963e04eb0013d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ca4b7ced4f57202ad4e2cd763df2ae9df4ed1a0425d96a203f68658c3b1741e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9e904b43de8d4cca5649f91edf6f927b800d8f081a72c596add7de25d2464f2"
    sha256 cellar: :any_skip_relocation, ventura:        "22dc849c8f7bda62dd9dd50876d1f666358960f49ca9d6c567c79df8a0f8687c"
    sha256 cellar: :any_skip_relocation, monterey:       "d3642b8f9c3e01391f06e48382b48e3b279058ee41ecd0cbd6127a097c86c0d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "346f3b22cc369c0905049b3e7139d03a168559fa0b3def8c3a4853e0dd035d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59ce185800f1436bc42e8272ceec9aadc5ecc758e791e93a5363fe300a1bcbc1"
  end

  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  def install
    virtualenv_install_with_resources
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
