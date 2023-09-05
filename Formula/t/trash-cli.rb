class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/42/2c/f9e598025b133d170e35becaef27fdfa86c7279d2715d20b517468c80c76/trash-cli-0.23.2.13.2.tar.gz"
  sha256 "99805170df2af7b291314d5b9d86b2cfd598e635a5a23d32debfede880021044"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411348e2a47d7fe324c9cb4b986a03c8754fad1a662502e792d76bda348a759b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54b56312c420747ff57a11d46d86aa13cfa6f72267bf7599ae358f0fb48da8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46ee21d95fb96184632d2560d88702ec16963b0080e1a1f76c8c7fc08d30fec9"
    sha256 cellar: :any_skip_relocation, ventura:        "573301ee4b89eef02b6c806be6c0105c06aedd4cec5373f268327ac0640e7d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0b42fe89ee7ee2e2b31e480cba546fe3dbfa701e5a80641d8cc376bc698f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e79dd411bbd4e5edda00083698bce0a1016b56cdbf19652321de642d50f69ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982bf29c252c2e921b3f1ad92ba9008bb75ed1719524f42695f7b153112e0713"
  end

  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"
    sha256 "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/trash*.1")
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
