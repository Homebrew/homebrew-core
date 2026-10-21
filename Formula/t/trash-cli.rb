class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/a2/53/5eabf92b6057df00f97ab8f92a8463da4a934dffed57daf0897569be78e0/trash_cli-0.26.9.29.tar.gz"
  sha256 "2ca3300fd9f3b0334cb3f576a3ec95ced8593cc729df4332608d69a28eb50fb0"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04268e97c1da1b84dfe9f6206a45a94921253c0e3fab08e97b5961ad6d0afd0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a6144dacb34d2ac1bfc3f5180aac37d575f8eb7f75200730e8970fdb00c08d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0032cc531121a61087393bd3d65fe48e501dd39fc1b2be7497a8387cbfd28d7e"
    sha256 cellar: :any,                 arm64_linux:       "64bccc25d669b27066a67daa38498bcc4c1fe4eb0680de68b4d8278fba8919dc"
    sha256 cellar: :any,                 x86_64_linux:      "75ef0b13712264de3d36d8c969250d6a5753f126725bb358ec68a5c20d96b4d1"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.15"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "osx-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end
