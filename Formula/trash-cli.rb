class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/25/75/8133fdc6b4bd9a9cf3e7ba80317308064f899b474ca453c21e3006a7a651/trash-cli-0.22.10.20.tar.gz"
  sha256 "14e0a95cd6d3943ef682530568d7894366c1733eb07723e693c5410a3c74fe0f"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "783f8a90b57013c3d805000e3f7e2966b61037980655ef193bc5a64453fe2b42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae573265f69e2ca674d73a261ff27451108938c8cef999c071d7d1f704eccb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0297996b7296604a3999834bf9d199ab645bcce73b0429446c4dbb57b25cda"
    sha256 cellar: :any_skip_relocation, ventura:        "e4ad8b00754a30f6f1bdbec8b194d8c7efbcd369b3dafd651175b528813143ff"
    sha256 cellar: :any_skip_relocation, monterey:       "455b0229a0f8e1ea0f2daf18bc39bd52e76036d59df4873e888ad251e23b9973"
    sha256 cellar: :any_skip_relocation, big_sur:        "9472fa4fe5d5b04e1d856e39f159f3a38b220ad09e96c7eb22d2dd15f979f0af"
    sha256 cellar: :any_skip_relocation, catalina:       "8451101a8557e07b2474b0db71f76663bb7edc0e9626c3b1e92cd94bcfa0da5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15554cb331443b20939188eee31764ad0d0fce83666d43fd63acbb0b4d3148b9"
  end

  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
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
