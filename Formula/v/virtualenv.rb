class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/68/60/db9f95e6ad456f1872486769c55628c7901fb4de5a72c2f7bdd912abf0c1/virtualenv-20.26.3.tar.gz"
  sha256 "4c43a2a236279d9ea36a0d76f98d84bd6ca94ac4e0f4a3b9d46d05e10fea542a"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a187d7b4c8941e622a9ddd13fabb53e5c2d12b25463489609511966d04c532c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a187d7b4c8941e622a9ddd13fabb53e5c2d12b25463489609511966d04c532c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a187d7b4c8941e622a9ddd13fabb53e5c2d12b25463489609511966d04c532c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d32158f05da777d733fc3bd1acb0ae6775b9f80e685dca698bebab8fce7a3f5"
    sha256 cellar: :any_skip_relocation, ventura:        "9d32158f05da777d733fc3bd1acb0ae6775b9f80e685dca698bebab8fce7a3f5"
    sha256 cellar: :any_skip_relocation, monterey:       "9d32158f05da777d733fc3bd1acb0ae6775b9f80e685dca698bebab8fce7a3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7556e8871dd3d1dde7bf7b8c3cd2a44dbbc300c93bd24da78d6370295c99dc54"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/98/6e68cf474669042ba6ba0a7761b8be04beb8131b366d5c6b1596f8cdfec2/filelock-3.15.3.tar.gz"
    sha256 "e1199bf5194a2277273dacd50269f0d87d0682088a3c561c15674ea9005d8635"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
