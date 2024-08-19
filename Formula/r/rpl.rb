class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/40/ad/840b679493c49e0c4368662e2ddd6296f9bac41e8ee992e0d43d144b4f35/rpl-1.15.7.tar.gz"
  sha256 "5eadc62dad539d2e27a1b3c71c2905504a3dbe02380c6c98dbf8505ad9303510"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59015416ba8ad9993261a50d78c24c60aa606b0b39f4777521f55d834c5e5cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dce5e52f2472bacc14700c111ba5940ac0716123707dcb938f379a8a43df475a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397ee7b7b672f1e0d3debe4c36c94bea1185762403503253426743483974029c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c5f5b86c9dd8bd32b98488eb679afaad4a06d3f53abcfbc7f0b4422250de3b7"
    sha256 cellar: :any_skip_relocation, ventura:        "24545f8ce43bfabe8599c7c2df6c488954786b32a3e692aa345889c6afbd7942"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ec7966aabe42f8bcff6e4e6263f9f4d028161bcfce30bcdcb39299d97281c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7eb5d986bc69e230e3ba7d3da3f029f624992b96948a82c8b7b976ee441bf9e"
  end

  depends_on "python@3.12"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/3f/51/64256d0dc72816a4fe3779449627c69ec8fee5a5625fd60ba048f53b3478/regex-2024.7.24.tar.gz"
    sha256 "9cfd009eed1a46b27c14039ad5bbc5e71b6367c5b2e6d5f5da0ea91600817506"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
