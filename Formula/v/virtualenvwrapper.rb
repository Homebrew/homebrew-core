class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/97/0b/1f6daec2e0bd25275953256f83f98fb337b78b9d03d44b7eb9619b72b046/virtualenvwrapper-6.1.1.tar.gz"
  sha256 "112e7ea34a9a3ce90aaea54182f0d3afef4d1a913eeb75e98a263b4978cd73c6"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22eece00e9be774f949fb58b1f5e3b3bbfa116517091866f2ff24b3db8c92706"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/aa/a3/4d310fa5f00863544e1d0f4de93bddec248499ccf97d4791bc3122c9d4f3/virtualenv-20.36.1.tar.gz"
    sha256 "8befb5c81842c641f8ee658481e42641c68b5eab3521d8e092d18320902466ba"
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
