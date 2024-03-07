class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.bezdomni.net/"
  url "https://files.pythonhosted.org/packages/27/b3/b76c839730b30e9a2a2124ad923b461208b4c66618b82c4a477856d582cc/toot-0.41.1.tar.gz"
  sha256 "7d251f7b6d39d2646f330c8bf2091eb82d6b76804fffdf20ab7ebb4055a63c49"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a02b8fd4da757e99e09bc25b9d905523f5eed640132c698c97b628b1e9adda60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbcf4deb231e7db6c71e04397dd7e7cfb0757ab64fbebab55a8579eb2922b63f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "653d795a2220a549a27635c4ea4070407d89f32252707882eedf19d7bc362f14"
    sha256 cellar: :any_skip_relocation, sonoma:         "18fc6ac67f8676a6c20d7df7c7ffde86f58f48f696948bcd0e97ca78d6c533b8"
    sha256 cellar: :any_skip_relocation, ventura:        "d529e6237ba0592c4671425f9d923f13e8662910ac2efff23099dc43e2dba74b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c50f83c039abf9361067a9b750f974f90f04b624f7542a22ee08fe4a724d475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c33e35cec9cacc293440840b2f79602917d5b2d68d4cc3bccaeabffb93b101d"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/97/52/0f9b7a2414ec1fea3aff598adffb9865782d95906fd79b42daec99af4043/urwid-2.3.4.tar.gz"
    sha256 "18b9f84cc80a4fcda55ea29f0ea260d31f8c1c721ff6a0396a396020e6667738"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot --version")
    assert_equal "You are not logged in to any accounts", shell_output("#{bin}/toot auth").chomp
  end
end
