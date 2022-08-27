class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/ce/93/62fa6fcf583c61f1ce21e1efaa0509729a72f9f1ebbf5f3664e16779ed00/trash-cli-0.22.8.27.tar.gz"
  sha256 "b2799ed134c3fb2880fed12995ac9d9937466d86ff84936c16408f8d5778737b"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a4a399a37fbbafac61f1e80ca989c942974cee3601b4a2f20ff8f91aeba8aa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba31e29b1050f08e0b595f050092ef3fea00fa78857b7dd6f88a01e3189124a6"
    sha256 cellar: :any_skip_relocation, monterey:       "4f6aaee7e051a5fc2e75d64022e91b654b92b2dcd17f7bdd5afa87e4e3111968"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa75a1633b2a0e9499a66a211836127b287ea6f722870868ee7fbf261b9df10f"
    sha256 cellar: :any_skip_relocation, catalina:       "e031523340f3f052ed33cbebd26135ee1148ba95ecdc050e64179370670078bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "963755b5a5fd00d419180ae485131164dcdd127e1cbf296575200916f4092700"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
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
