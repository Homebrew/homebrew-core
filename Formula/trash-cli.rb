class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/0e/93/fee4f93055533eac0c9093c7d2fbdaa97173826f7bb085e52db5c034e05d/trash-cli-0.22.10.4.4.tar.gz"
  sha256 "1aabbcfd973888728fff1c9250d7463b3be79a24d4194feebb63a32615162c50"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa42171543c29db2c9ec42b18e900a400ee896ea677132af451920f9616995fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f6b16e53ec7ca7aa75ee1d1cee58d59917b8893aedbe7010dc20455f9bad1c3"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ac8e58a4bba222668e8cc7f54f938db78f9df8b277b141d602096e4fb3d8f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f573a8918229f0899ecf5920e687c6c3132e43f153c54b1e42612c3f05143c4e"
    sha256 cellar: :any_skip_relocation, catalina:       "986bc6594d2e4eb6a27555d5c990228409ef62b882522ef19f2cfe6eb8acc89a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2ae4f73f4e65187c6e99d46eab57a80144f8bf07e342e4ae0dafc311d09706d"
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
