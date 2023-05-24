class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/19/ef/8900501b1af41d2485ee1eabb9f3e309f80fdae911c97927d8917ae99f9f/RBTools-4.1.tar.gz"
  sha256 "24efb20346b905c9be0464e747ee1bdee7967d1b94175697ea0c830d929475ff"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e975997b40ab9dc103ee682f0833c038d42e2e9ee8940a1f0949c467ce7414d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69012845e651178a9e85e50cf8d0e168b77e76c7984519deb2f354831b1d8014"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36d4cf877244f1cc2fb24a751ad235e4bef79d889501c757fd10f1fa14974ed6"
    sha256 cellar: :any_skip_relocation, ventura:        "4d2c2867e1eedc50b0f68789afffd43f0485f98f43e7ced05f2d611b383172ba"
    sha256 cellar: :any_skip_relocation, monterey:       "395d556690693f09ebee1783966f5b02de18bb95cc7b0d3de80488244028e2d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4db34762cde42858275f0c85a9b948bb46f976b747455f3f21aadee64426404f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2387a79a508fb0503e7271cea7ae635323f01aeb208adc37cc06b34fc251eb23"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

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
