class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/72/ab/e35e3b8c51367dc6b4d4430f3141e93421a15f16e9f161acad7c2b640107/trash-cli-0.20.11.23.tar.gz"
  sha256 "c4c2d1a1f518b4de3de2b168f970bbeec739490204e0bf5c32a65004c09fa2ad"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cfc93dc305e620eb718ce9b9b678d441facd80e08ffb1a796b4df00351f3eb2c" => :big_sur
    sha256 "10165586325ca98613ae30f9384147625b1050f703fd95b082488df5d5100aae" => :arm64_big_sur
    sha256 "128888973578e454a51de84730d0003039081a46902fc644b34c75d903177a8a" => :catalina
    sha256 "6cb8a2b0d695b6eb65835110d3d45ab5b63240a7feb423fd548b7df551b32d5b" => :mojave
  end

  depends_on "python@3.9"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

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
