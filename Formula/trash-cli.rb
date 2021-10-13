class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/43/ed/ba5970572a6fd1332b8949b4c256954cd18d38764866504aa63f4322957b/trash-cli-0.21.7.24.tar.gz"
  sha256 "6cda4be92e19817fdd691fd8a9c5fa041c3b98761848ba353f0fd73cf1fe2710"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e69b6562ad18a8399b66c75c06580b6cf2a0c11358b1b181b49afe4cde0deafc"
    sha256 cellar: :any_skip_relocation, big_sur:       "c16216b6f9a0028db448e30c7e7b49b327607e8790a75a0b5712365091827967"
    sha256 cellar: :any_skip_relocation, catalina:      "bb81e8d992e490f0315b221fd0a5b0ff47b314ba03ce132a4b5b2ebab93d05ef"
    sha256 cellar: :any_skip_relocation, mojave:        "9dd15c300de154209d420785d8e83e76b6784353539e5843a5b12b07cf6cbad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "804dcf2465628fdb772c226d1601073c79c4aa607d00d21dc2678a7823f7f822"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
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
