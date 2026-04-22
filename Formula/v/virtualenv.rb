class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/0c/98/3a7e644e19cb26133488caff231be390579860bbbb3da35913c49a1d0a46/virtualenv-21.2.4.tar.gz"
  sha256 "b294ef68192638004d72524ce7ef303e9d0cf5a44c95ce2e54a7500a6381cada"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74964bb15618047084e818e39f1db52d317435d447f1f54d0ed5b070daeb321d"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d6/17/6e8890271880903e3538660a21d63a6c1fea969ac71d0d6b608b78727fa9/filelock-3.28.0.tar.gz"
    sha256 "4ed1010aae813c4ee8d9c660e4792475ee60c4a0ba76073ceaf862bd317e3ca6"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/de/ef/3bae0e537cfe91e8431efcba4434463d2c5a65f5a89edd47c6cf2f03c55f/python_discovery-1.2.2.tar.gz"
    sha256 "876e9c57139eb757cb5878cbdd9ae5379e5d96266c99ef731119e04fffe533bb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
