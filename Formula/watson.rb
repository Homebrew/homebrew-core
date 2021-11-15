class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/59/fc/cd80b0504fec73821ccbdbb276e0ea2092d1be62f0a7ca7722d8a0cc4368/td-watson-2.0.1.tar.gz"
  sha256 "a665775a76fb3ac464153e10991577a38ca938adae2142a24c9d1b1234db95f0"
  license "MIT"
  revision 1
  head "https://github.com/TailorDev/Watson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dff1bdd517692e212a3ba6e1bcefbb46bf0388da370ee050153e816b42417f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf07aab5cd5de88d5fbd6fbeed35147e6e67632036740bfdc7542892d4de0d07"
    sha256 cellar: :any_skip_relocation, monterey:       "ec2db9fee1bbf9a1239b33bd7ce02bf1ecbcdab0bbf142e48629087e33e65da5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bdd85818b61af3db8e38075700e27432f78aae2374d3086d676ba7244e468c1"
    sha256 cellar: :any_skip_relocation, catalina:       "e7119a6c5cbbb3c00950765a5c10b7f7274742f3811c7ecc486f45bec084b787"
    sha256 cellar: :any_skip_relocation, mojave:         "ace29559758de8e640ccec1f1ea06d17aa6fdcc793b66a393646a6a4292f230e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be693598e1a92a5cf781e90f148c915d4673a880bedef7bf1deecf5f1b79668d"
  end

  depends_on "python@3.10"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/0a/97/e58a3cd2207cb9cb7aa9b91f3bc4df3b4e13eafc88d75b1a9f4535ea6e1f/arrow-1.1.0.tar.gz"
    sha256 "b8fe13abf3517abab315e09350c903902d1447bd311afbc17547ba1cb3ff5bd8"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/9f/79/d265d783dd022541b744d002745d9e55d84c04a41930e35d8795934f6526/click-didyoumean-0.0.3.tar.gz"
    sha256 "112229485c9704ff51362fe34b2d4f0b12fc71cc20f6d2b3afabed4b8bfa6aeb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "watson.completion" => "watson"
    zsh_completion.install "watson.zsh-completion" => "_watson"
  end

  test do
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
