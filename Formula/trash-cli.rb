class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/bd/74/b750ffd6d1319bb6693d764edcc31b3bb94d2dee600d8361c9d0602f42f7/trash-cli-0.22.8.21.tar.gz"
  sha256 "1a8dda3c7131040659f81ccc19385129f0dd6da035b7be55178792bff604ca18"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a14588a5d88753319490da3c2deffb7f9a4870653b74c347a6d8a0614682490"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b33f708f53497d0d83d96e66a2c7fce956f36389ca51e192d52abbdf74bb75c"
    sha256 cellar: :any_skip_relocation, monterey:       "da88c8d934a34fc2417ecfd7f2710b673e2e18d615487793f37d75399fa8d31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "71ee8bc4d612c8884b84ecbae78eb756554ad7263bb5e920093987aefc6cd6d6"
    sha256 cellar: :any_skip_relocation, catalina:       "2fe9e92b0b34e42ee79952e37ae69da0f516b1bf9998a9444665933f32c88eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2c2823994fd585fa7428e09ec2100ff1abb74249b818e6252ec055b165a284"
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
