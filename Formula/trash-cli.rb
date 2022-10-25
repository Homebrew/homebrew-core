class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/25/75/8133fdc6b4bd9a9cf3e7ba80317308064f899b474ca453c21e3006a7a651/trash-cli-0.22.10.20.tar.gz"
  sha256 "14e0a95cd6d3943ef682530568d7894366c1733eb07723e693c5410a3c74fe0f"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59cce5a6ae59edf4f1550f0433e541c39f2da61deca926dd5d3e9eea979d0c53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e4871fadb81e41ee9c3f15b132d9f15561500ba7816589a26117320f0a85ccc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706a6ef3fa3de5d666031269449166f76e5c4f336e45f420a3a4688f183ac745"
    sha256 cellar: :any_skip_relocation, monterey:       "ec28f4e085a3fb52faa480b536ea8aeffe20f31322307f5b3fb44bf4986c96b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6cbda37886d0ad416d20ae20b40df09579b29c3d55dfaeddc01e153095f8a17"
    sha256 cellar: :any_skip_relocation, catalina:       "6d47fcd5247911bf496982ca231ac851abb4c577a635753e4941698c25db3d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "721ce0320688a237da9f4dc1b20a72f5d325006d85607d334fcbc1d67aa01203"
  end

  depends_on "python@3.10"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
