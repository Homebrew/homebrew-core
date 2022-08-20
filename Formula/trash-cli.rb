class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/89/8d/ca21ac5cab9967023806fc666ee874ed211e441b70276be92d3f2ba08ecf/trash-cli-0.22.8.19.tar.gz"
  sha256 "f1e92eac01bff0bf878ce62e9689589bc6d856b58959f8f0c74ce9787f049f5f"
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
