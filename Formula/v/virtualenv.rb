class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/44/5a/cabd5846cb550e2871d9532def625d0771f4e38f765c30dc0d101be33697/virtualenv-20.26.2.tar.gz"
  sha256 "82bf0f4eebbb78d36ddaee0283d43fe5736b53880b8a8cdcd37390a07ac3741c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fafad463983dcef9ceeb7180a0d8082f0a21a7e03849d74e13d248d65a2cde1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d41c26d0565120d650ceb6baae0d0a39a909f4183280d6e9b3f577f3f7884b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73c4c3caf40272c284350f41c196d02a3d605399aafd3af0b125ce18892b0de0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc5a90176dadd6ee9d0fbee6fc8e6677fce9525ac238c58c315953a7c597e0c0"
    sha256 cellar: :any_skip_relocation, ventura:        "b235e85b6e2497ee70bdfb7cdd4d94372c437f1353302caada36bad5ab772e6b"
    sha256 cellar: :any_skip_relocation, monterey:       "62be0063ef44583912ba68677d18abe13c6bd3f1b86506473b2b0c1e8d1a876c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fe5e91d24a61daa71be01a77122722266f4597f78f92264836c789f8ce61524"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
