class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/67/a3/0d6c29913eba3b859770e90bf9f298670b0e4624f56ad0960f58177fc772/trash-cli-0.21.6.10.1.tar.gz"
  sha256 "63c1147bd905f7f157e9056f4d519a8457d72e6ba57b6ff9ec5cd4034e14ce19"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "828d1befbfe3e56be926c56b9715ad4453706fffc7c8dbe29abb30a5debcf92d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d697dea2bd8f7935ac6047d8bb0c86d7ed72c635dc6d8af0f19603a2686e67fb"
    sha256 cellar: :any_skip_relocation, catalina:      "ec2930cc4dfefe732cd9a3a24c64deec8ba02d418e485ca1edf5aebf6170012f"
    sha256 cellar: :any_skip_relocation, mojave:        "6324ae3c7943d7823d6f3b7571777e34acadfe56e2b233cff84ffaf7c3f9ba4b"
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
