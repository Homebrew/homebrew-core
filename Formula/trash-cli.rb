class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/36/d2/6415cda6cdd81ee0eb07b357e96a03c96a78af324d7eb2c52ff51d080210/trash-cli-0.22.4.16.tar.gz"
  sha256 "ec60ff1a038402f4b1e7360b32707bc36dc275fa32e512bb81274c0375d20003"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e3818a4e7d566a5a229cdeedba409fb7390a3143499831b77591b59b4a7766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cca5e7c78dbe4eb57c7206cf3a2625b6c679d244cc2b4257ae6d0467e803f18"
    sha256 cellar: :any_skip_relocation, monterey:       "07369a42a8cf8486d55efa95eab6de82bc27af1b4464b899197eff712881a28c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fcb0993e023421ef2ec1b19f141424b4f5d331906a33ce7ad45076daf050961"
    sha256 cellar: :any_skip_relocation, catalina:       "081339ba0b9e550f38cd7e9be1bca5f16785f232769262cc87b6a8bfc8df8724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b530cc6b1e62d040f7521d96648f84aedb1ec9de92fa5df48d5605e567046c48"
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
