class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/4e/00/71629f631867c434e49fa276d659894c7cb5715f5de2233c10bc47c1fcc6/virtualenvwrapper-6.1.0.tar.gz"
  sha256 "d467beac5a44be00fb5cd1bcf332398c3dab5fb3bd3af7815ea86b4d6bb3d3a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a90e2263d38d0d3ab6dc6d1bafbd9e75d3d05471d078b3f16046aa4b61cfcde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1072ed62c67138b7424ed34069cd8325564a2e0294cf7974cbffe4823dd7bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22013ed67797a18484d863188024430bb64951f6766ac51bb98cbd75696b4ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe67aba6cc7c349860a5afe5813f8d8eb5d998196cf3155f8ad5a4f1eb7e8b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "de96173160e4b3185109f10d51ee254b73f567b7cc73abbb73b0c807b4a0c4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "5931223a14d8c89970297f6298041b4b0fdbeb46ba41d8565aea9589b5180356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98d276306cbdc9df1ee2f7fe5bfca450525492923c3b634b9dc1544a8be5016"
  end

  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install_symlink libexec/"bin/virtualenvwrapper_lazy.sh"
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/#{python3}"
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
