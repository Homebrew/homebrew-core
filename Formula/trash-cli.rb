class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/c4/17/3d153e9ed159c8ab0e01fb3d991e7ac144c6a995d788ad96085c3ee7a093/trash-cli-0.22.8.21.16.tar.gz"
  sha256 "ef77198e79ac02608872c027de91c0e18353f8d2bf1b7d11a1d8bde66fa5669e"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52a99cf1f3f1af0b0e4a3126bda6baf2eb7577511d9d9c361cc02b8b31dd4858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b4b80cf3c527a2f893f39b357a61e823f3f770623b2f3d71be160881fc11c19"
    sha256 cellar: :any_skip_relocation, monterey:       "0e439386a9b0ba4781a274cf75341955c130b824bc20579b520e715b9e81cabe"
    sha256 cellar: :any_skip_relocation, big_sur:        "039c5483e657698035de002766c88741c24d5b9a4f81a92a666d403fea2d89c2"
    sha256 cellar: :any_skip_relocation, catalina:       "a8d2bf1992061047b2248d63ee2051277c9cc0a17eb02d51272a7bfa015ab28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ef84e87eda126a280384b132f62c4dbc7e57a7d86effc5dfd85274b1e91108"
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
