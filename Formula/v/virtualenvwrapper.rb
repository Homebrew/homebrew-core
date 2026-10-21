class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/97/0b/1f6daec2e0bd25275953256f83f98fb337b78b9d03d44b7eb9619b72b046/virtualenvwrapper-6.1.1.tar.gz"
  sha256 "112e7ea34a9a3ce90aaea54182f0d3afef4d1a913eeb75e98a263b4978cd73c6"
  license "MIT"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "162afcc33a3daf18071007422d3ec7c58f53379ee337e9ddeae0c1ac952f820b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "162afcc33a3daf18071007422d3ec7c58f53379ee337e9ddeae0c1ac952f820b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "162afcc33a3daf18071007422d3ec7c58f53379ee337e9ddeae0c1ac952f820b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d794b4cc380d0cd52bae398ce5c540ed2487a7e2e0ca08ce990a3a006cd43f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d794b4cc380d0cd52bae398ce5c540ed2487a7e2e0ca08ce990a3a006cd43f30"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4c/58/6fd434bec86eff7c38a3168454cb132b762b2bea9b3ac094101a2f7bc32a/filelock-4.1.0.tar.gz"
    sha256 "ad7f724afef953e731b1cc39bcd3a09166d72ed7fcdf29e6e88b1c3235c6715d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/b0/73/54993df8fc57e906dc9b7e01d1d9b0b2d3eb0ce3190639e33dccb12853f7/python_discovery-1.6.2.tar.gz"
    sha256 "cd1738ca1d37c86ef9d0b654dd46fcee1e41c97c6add12575e8501ced39afdb4"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/92/f3/589727d02bc832750cfa00ced4315d127535a22a6d7cfcb369b2fe219a2e/virtualenv-21.14.6.tar.gz"
    sha256 "c6b74616e64bffa9532cfa9dfd54ffbab0dc9b999df2bb8ec0d75e559b983661"
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
