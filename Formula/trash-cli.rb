class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/36/d2/6415cda6cdd81ee0eb07b357e96a03c96a78af324d7eb2c52ff51d080210/trash-cli-0.22.4.16.tar.gz"
  sha256 "ec60ff1a038402f4b1e7360b32707bc36dc275fa32e512bb81274c0375d20003"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f22f52eb68318c67189088bb5d259f7e8eb8bf0ff97179016211dd3338e194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65f25a055716ff1a6d02af8ebbd1277bf7aa867041192f6c2e74b9706d4d0e68"
    sha256 cellar: :any_skip_relocation, monterey:       "4f76efb6145fa8c9a2c23ce4060f8f07dc858c1b52a149a77a36ada9fcb92904"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf648273dd62403fa33b8205dd060aa4ac46aa9c57954322b2a709441cf28186"
    sha256 cellar: :any_skip_relocation, catalina:       "d210340ae88ff9efae48adc44b9413dd5b0f7671c72cba6bbd116860e9f887ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8432914e1ba2d1392a8fabbc64861e5363d5725d0086b02b58096652db195c4a"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
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
