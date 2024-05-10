class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/6b/2c/40b5a7f7623986d784272290eedf6add4c266798ab92d0ab11b1e24aedc2/trash_cli-0.24.4.17.tar.gz"
  sha256 "8a540b16856cf316dab5d9507b6bb2cb46f7bbdbffafa63795c5242630ce3046"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d50fc028c19088243cd2b36e286de1d953385995bd4fee7b75bca9f8be4434ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c694c0cc0a34b681de2a10c11007ce8753d1eb268ae36a06e17a8c825f070f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b8fc1c919a0db399d9d0f775d229d7fa6ca938b70df067504042d1ae869283"
    sha256 cellar: :any_skip_relocation, sonoma:         "62add985bde949b19d8160b80333e0833db61d1ded787bb6675200dc4d9f1fa1"
    sha256 cellar: :any_skip_relocation, ventura:        "a8c1d959d128fd5f4261e1189a1714d07161c4e46118bafbc73397891d9e537e"
    sha256 cellar: :any_skip_relocation, monterey:       "e1255ba303582b11f0220edfb40e38ab430b53044a35842fb76050da37ee8509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027a7f561eac59bc35d4f0b577887eb6b4325fa44ce223e54d74204d4aac9cda"
  end

  depends_on "python@3.12"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
