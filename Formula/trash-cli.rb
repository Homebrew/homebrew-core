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
    rebuild 1
    sha256 "5709ac7582a562b73ee9990da76d1e47eda1c9462de1b27c1002058a8bf4a95e" => :big_sur
    sha256 "3338c06b98502ac0541819df14c9750f60396a58c7c0f96fa2c94af1d13f6497" => :arm64_big_sur
    sha256 "181a25c6c47163b33789da438ddf5ed2f8b20be195a3ac1c2e4043b0a2ebcd90" => :catalina
    sha256 "c7cba34dc885096b61e2f3edb8ec473c625ae71342e42377e588a371ea475cdd" => :mojave
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
