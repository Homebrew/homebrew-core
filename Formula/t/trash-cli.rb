class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/f7/6c/d51b36377c35e4f9e69af4d8b61a920f26251483cdc0165f5513da7aefeb/trash_cli-0.24.5.26.tar.gz"
  sha256 "c721628e82c4be110b710d72b9d85c9595d8b524f4da241ad851a7479d0bdceb"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3005369e1cfe7938d6c97d39614c2dd45bb87b06d2e7fb07e1616a201d8128b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ccc13a1742713858b3b63cc8feb9840596b901d2ffe5dc1fd9757ed2584d1ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4ea7729d8301971fd3970a2c72b8ab6d4a08df8b82a79d9146ff95e2880db7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81d30387db79999d4ce0eb0b656d97ac782c6de9531f6cd052b83311a145c02"
    sha256 cellar: :any_skip_relocation, ventura:       "31f699dac8d5ded90260901e92ccd1fd21c4319732b0efc258385bcd3c004411"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aa53d7fd0525290529f1de305a1e5c701e8c9948874526fb281e201bd36f6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4712d02377f336fb88f4de3ebc3c03dbfcf1a17d8e3d8aac297570a2938f5dd5"
  end

  keg_only :shadowed_by_macos

  depends_on "python@3.13"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
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
    assert_path_exists testpath/"testfile"
    system bin/"trash-put", "testfile"
    refute_path_exists testpath/"testfile"
  end
end
