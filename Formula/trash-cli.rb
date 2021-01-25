class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/8b/ab/710110ccdbc46e41f5cc6f196b1d94f4bc2f0bc7c26a3bbe0b263790b248/trash-cli-0.20.12.26.tar.gz"
  sha256 "3b42917b09c19935afbb9824238afba05dd72c0e340c0ca0acf84e04b3e60879"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24574061108b1eb0906b573baec0aee240229a5011b7a02e3b139e664f228a99" => :big_sur
    sha256 "d1e5b0d1d167a67cdeb66d1f7490cd83693c8a8986d89ddc5028791fc3827945" => :arm64_big_sur
    sha256 "64cfdbfbdce3a999c438d36b67ce6b3473ce9547f8320258e3da86ab7c12e683" => :catalina
    sha256 "5a638963dc04946eba48aa9dbcceee188dd055459ca62883228cf4a40385bb83" => :mojave
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
