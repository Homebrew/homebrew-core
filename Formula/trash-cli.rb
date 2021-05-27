class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/6c/e6/10b85ce1e8abf94658b912700d74e23b6d0ea9f01f7fbe0019778f00ac9a/trash-cli-0.21.5.25.tar.gz"
  sha256 "c58905b04a60bb70231648ac6f280965a4cfdd2e2682e6d94b12f99a40620538"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "548f058a880df05e865c88ac97a614c0f785aeb4618c1476aa85f445d879f4c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "108b8c5f23a7dd8e9ad5f6138250c2692591c1317ad4a32f4f31d7b912c9898b"
    sha256 cellar: :any_skip_relocation, catalina:      "61043f858809389a578479525327b17d5879a481828352132f803594616b09e9"
    sha256 cellar: :any_skip_relocation, mojave:        "d8f9cb7dfb7e079e4329d9f09d1fe2431b23064174211881585d36afc17cf9ca"
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
