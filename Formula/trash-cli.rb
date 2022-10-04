class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/0e/93/fee4f93055533eac0c9093c7d2fbdaa97173826f7bb085e52db5c034e05d/trash-cli-0.22.10.4.4.tar.gz"
  sha256 "1aabbcfd973888728fff1c9250d7463b3be79a24d4194feebb63a32615162c50"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b80c2a8f0ae5fc6988752c7412cd1c871bce83ca45ed9c503a4418ae81aa99e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c224c39d66d68481d17b38a335a5e691b71b1bac34f44e17a87f0d1ad23d3b7"
    sha256 cellar: :any_skip_relocation, monterey:       "196511eee07b681da088e4f772535eb2160888c17ee691f5214f75eead774ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "de7f8249496d460760b21216f559d4b437b1e41b1d45efffd7e7ca1eb143392f"
    sha256 cellar: :any_skip_relocation, catalina:       "8106839f9402b59c7c68c21b8e6ed0c7f779dbe1252cdc363474323e643ae792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d5e9a1bb0af0be9ab8bfcbda19444b071e1dff5f27c19c6c83e9ad1c372962"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
