class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/43/ed/ba5970572a6fd1332b8949b4c256954cd18d38764866504aa63f4322957b/trash-cli-0.21.7.24.tar.gz"
  sha256 "6cda4be92e19817fdd691fd8a9c5fa041c3b98761848ba353f0fd73cf1fe2710"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b888dba8addd6a5f2ad4fdc9fa8aca111727568aeaee605762a100ea91ae2178"
    sha256 cellar: :any_skip_relocation, big_sur:       "f55385d97429ccf5a951ed573cde5730a0f673c9a9321c75961057446bd9845e"
    sha256 cellar: :any_skip_relocation, catalina:      "7a8e747674c4bec7976110fabffcb361761543950f3f6cac15c27e753e323dd1"
    sha256 cellar: :any_skip_relocation, mojave:        "620fae73a3540e5d9751225455a95b03b609acb05c3ae44b9f8be757cfd9344b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd48d148c010b625d65ad048e7afad91afdd2e7c566a11b88e1b827b8218c3fc"
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
