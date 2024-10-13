class Rpl < Formula
  include Language::Python::Virtualenv

  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://files.pythonhosted.org/packages/40/ad/840b679493c49e0c4368662e2ddd6296f9bac41e8ee992e0d43d144b4f35/rpl-1.15.7.tar.gz"
  sha256 "5eadc62dad539d2e27a1b3c71c2905504a3dbe02380c6c98dbf8505ad9303510"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad4ab4a2e6499b351a9810927238c86e845914a4704e1d8b90006ff58f81c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2d9ef725b9958789e8be6289991f41860e36bd698692b3847b2a5aa5c87494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d32ea48792da526f31c50274047ad1552d12e6d6e2ce141ffb2c0f8d4cf4b379"
    sha256 cellar: :any_skip_relocation, sonoma:        "57400d05345044f6ddc33fc40396e2e335b1cb894abd2b489693043859b39f92"
    sha256 cellar: :any_skip_relocation, ventura:       "669ac7a78dc10e7dbafbffc0a5e91ecec53b9e86e01bcfc9612b5d5c1bf5cab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc886c7312e09183d3035bf33bfbb985d98593ae88e3ec4f707bbc12c2ba3943"
  end

  depends_on "python@3.13"

  resource "chainstream" do
    url "https://files.pythonhosted.org/packages/44/fd/ec0c4df1e2b00080826b3e2a9df81c912c8dc7dbab757b55d68af3a51dcf/chainstream-1.0.1.tar.gz"
    sha256 "df4d8fd418b112690e0e6faa4cb6706962e4b6b95ff5c133890fd32157c8d3b7"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
