class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/c1/6b/2f05d73b2d2f2410b48b90d3783a0034c26afa534a4a95ad5f1178d61191/virtualenvwrapper-4.8.4.tar.gz"
  sha256 "51a1a934e7ed0ff221bdd91bf9d3b604d875afbb3aa2367133503fee168f5bfa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83295a78a568991b7aa9523018a535d2e18a1fd7a121a971d02e501ca7d9454b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c547ff5d7e2996a3cbdf77bec31bc8bce007344427d8f65fb5c9efc94185b643"
    sha256 cellar: :any_skip_relocation, monterey:       "c2be7dfb6fcfa7efbb50cc700109a6f5d9f4a43c1a3c1da4be4e70a776fd29cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f30e47c1440c9569a3d29c4ef5c7336c96fb2e1acba97b711d1b8f44c1c6b9f4"
    sha256 cellar: :any_skip_relocation, catalina:       "a212a51c8e9b92ac771f7fe2ef10817d7d50adae826720d67e949c3b1bd8216c"
    sha256 cellar: :any_skip_relocation, mojave:         "dedc8670462702a9d8e1afae32874b1236e0e2af43b27111cc33408d854cd1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51f71071838cd60dfa30083e48274264acaff68499dbba7922a23dcf50a2e4b"
  end

  depends_on "python@3.10"
  depends_on "virtualenv"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/65/e2/8cb5e718a3a63e8c22677fde5e3d8d18d12a551a1bbd4557217e38a97ad0/pbr-5.5.1.tar.gz"
    sha256 "5fad80b613c402d5b7df7bd84812548b2a61e9977387a80a5fc5c396492b13c9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/95/bc/dc386a920942dbdfe480c8a4d953ff77ed3dec99ce736634b6ec4f2d97c1/stevedore-3.3.0.tar.gz"
    sha256 "3a5bbd0652bf552748871eaa73a4a8dc2899786bc497a2aa1fcb4dcdb0debeee"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/f4/6d/bfcfff1709d05143e71337db4800b30dd9abf0c41972960c9e8984ab96f7/virtualenv-20.4.3.tar.gz"
    sha256 "49ec4eb4c224c6f7dd81bb6d0a28a09ecae5894f4e593c89b0db0885f565a107"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/1d/51/076f3a72af6c874e560be8a6145d6ea5be70387f21e65d42ddd771cbd93a/virtualenv-clone-0.5.4.tar.gz"
    sha256 "665e48dd54c84b98b71a657acb49104c54e7652bce9c1c4f6c6976ed4c827a29"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install_symlink libexec/"bin/virtualenvwrapper_lazy.sh"
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/python"
      source "#{libexec}/bin/virtualenvwrapper.sh"
    SH
  end

  def caveats
    <<~EOS
      To activate virtualenvwrapper, add the following at the end of your #{shell_profile}:
        source virtualenvwrapper.sh
    EOS
  end

  test do
    assert_match "created virtual environment",
                 shell_output("bash -c 'source virtualenvwrapper.sh; mktmpenv'")
  end
end
