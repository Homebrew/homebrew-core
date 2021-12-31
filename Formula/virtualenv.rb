class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e0/49/070b07f330d9680f509e63c0a1f6712afc31e503dca2976b49b6f02c282c/virtualenv-20.12.0.tar.gz"
  sha256 "03dbbd4b2a85872a859dfabafc351d702a0b8ace8603da6eb2b90afdfb8fb91b"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a57815da9b341d47a364fa3a1b5e3ca7a45e5eb1d94b919bd6c921f3c13511c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff7761f83e58e66378bfd3b206a31154b9ad6c4041110132a430c856cfa1fe7c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b904765c1a34119a617b4f5df5499db324c51992965c89a00241e0147ff9b42"
    sha256 cellar: :any_skip_relocation, big_sur:        "e70cb83ebcc324818c6301827b7319e01925389813f61758a7e088c997c434b1"
    sha256 cellar: :any_skip_relocation, catalina:       "e40c1d860ff1e26a799c905690274b384d4b0ceaf1e644f7f9a170f23b1238bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16ce1461322820d403517126af629900a0927cf1fddaf4412b230c8a9608ed9"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
