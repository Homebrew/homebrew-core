class TorfCli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for creating, reading and editing torrent files"
  homepage "https://github.com/rndusr/torf-cli"
  url "https://files.pythonhosted.org/packages/31/90/b67f5f73353f419b172c8d22ebaf744750fa22af9eb4b52adff52a7706f2/torf_cli-5.2.1.tar.gz"
  sha256 "96f64e3f2408e8ca5a3567ced9f5ad2e9ef1d63e13cfe8836145ac36bad8ed54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b7758a90df48547bab1b1e348803e2d94ff4e056db3670f11ef23774f47739f0"
  end

  depends_on "python@3.14"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "torf" do
    url "https://files.pythonhosted.org/packages/85/1f/152db30a4f60142766ea7b16af2cae86b648359f300179d06eb06b079270/torf-4.3.1.tar.gz"
    sha256 "5c17656b2ad379122f2ec97a057398d1ec6a6bfce6f0b6f8ec0799b142493c5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.txt").write "Hello, World!"
    system bin/"torf", (testpath/"hello.txt"), "-o", (testpath/"hello.torrent")

    assert_path_exists testpath/"hello.torrent", "Failed to create torrent file"
  end
end
