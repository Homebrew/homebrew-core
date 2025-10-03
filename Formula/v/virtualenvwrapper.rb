class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/97/0b/1f6daec2e0bd25275953256f83f98fb337b78b9d03d44b7eb9619b72b046/virtualenvwrapper-6.1.1.tar.gz"
  sha256 "112e7ea34a9a3ce90aaea54182f0d3afef4d1a913eeb75e98a263b4978cd73c6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "11c07d0473e9177377e77fd5d9e15e0a6c63b3aa1c87e031bbf8f9ed179badfa"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/40/bb/0ab3e58d22305b6f5440629d20683af28959bf793d98d11950e305c1c326/filelock-3.19.1.tar.gz"
    sha256 "66eda1888b0171c998b35be2bcc0f6d75c388a7ce20c3f3f37aa8e96c2dddf58"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/2a/5f/8418daad5c353300b7661dd8ce2574b0410a6316a8be650a189d5c68d938/stevedore-5.5.0.tar.gz"
    sha256 "d31496a4f4df9825e1a1e4f1f74d19abb0154aff311c3b376fcc89dae8fccd73"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/1c/14/37fcdba2808a6c615681cd216fecae00413c9dab44fb2e57805ecf3eaee3/virtualenv-20.34.0.tar.gz"
    sha256 "44815b2c9dee7ed86e387b842a84f20b93f7f417f95886ca1996a72a4138eb1a"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    virtualenv_install_with_resources

    (bin/"virtualenvwrapper.sh").unlink
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/python"
      export VIRTUALENVWRAPPER_VIRTUALENV="${VIRTUALENVWRAPPER_VIRTUALENV:-#{libexec}/bin/virtualenv}"
      export VIRTUALENVWRAPPER_VIRTUALENV_CLONE="${VIRTUALENVWRAPPER_VIRTUALENV_CLONE:-#{libexec}/bin/virtualenv-clone}"
      source "#{libexec}/bin/virtualenvwrapper.sh"
    SH
  end

  def caveats
    <<~EOS
      To activate virtualenvwrapper, add the following to your shell profile
      e.g. ~/.profile or ~/.zshrc
        source virtualenvwrapper.sh
    EOS
  end

  test do
    assert_match "created virtual environment",
                 shell_output("bash -c 'source virtualenvwrapper.sh; mktmpenv'")
  end
end
