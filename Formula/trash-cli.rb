class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/43/ed/ba5970572a6fd1332b8949b4c256954cd18d38764866504aa63f4322957b/trash-cli-0.21.7.24.tar.gz"
  sha256 "6cda4be92e19817fdd691fd8a9c5fa041c3b98761848ba353f0fd73cf1fe2710"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29094a8a512a9f8be4253228d64f021925bfa3fb5d9d7ad41e1709c3301852b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "4960174ac7534883050e0e5494854f67e802e883ef77123fa2cf36c12b967c81"
    sha256 cellar: :any_skip_relocation, catalina:      "02d953ed6c556923c0f43b58a3243a108b2e22c23e75e16b3ca6cb62b5266575"
    sha256 cellar: :any_skip_relocation, mojave:        "303b3ad9d2b9d58c331c87f7eb2afc37edb13822257f6469a7a1b376d4e63e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852161d4c6340611f9e9de8b1c0c18e6420cb8cdac99ecb0ec2b06223efebee5"
  end

  depends_on "python@3.9"

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
