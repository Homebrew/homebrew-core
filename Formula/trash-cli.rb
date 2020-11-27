class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.20.11.23.tar.gz"
  sha256 "dbe59f60f3d0fbe95aedcc64b927e8d4d8ce62fc0dd9b6a0b8ffae2372865f36"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10e814e79699940cac7c66aef5daea1409efa4eab1a7f9bfa73cd479358f8f2a" => :big_sur
    sha256 "c1a141e61e18ec997069b798fa2f6bf74c7da727c37e2ccac93e8868160d164e" => :catalina
    sha256 "6db8ec702ddf03b341cc7e3e17996edfe4709f2f07e7f419b46aff9d931ffa04" => :mojave
    sha256 "79a1a6365236113da1a70aaa9c484e3951224a6436fdfa13fd8ddbe6733a9853" => :high_sierra
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
