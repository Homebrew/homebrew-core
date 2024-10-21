class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311cca4a3125dfedabd1d2ce843fcb82c20cb39985450e5938cf7d2949ac22fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a78cb051f1bd38c7a7403f0d290f614282f4fcb75606478f642a405d94bfedf"
    sha256 cellar: :any_skip_relocation, ventura:       "8a78cb051f1bd38c7a7403f0d290f614282f4fcb75606478f642a405d94bfedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78324721748810507339a113338a63874c4174d390b195f869e8238ca216282c"
  end

  depends_on "python@3.13"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cd/12/33e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1b/importlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/54/bf/5c0000c44ebc80123ecbdddba1f5dcd94a5ada602a9c225d84b5aaa55e86/zipp-3.20.2.tar.gz"
    sha256 "bc9eb26f4506fda01b81bcde0ca78103b6e62f991b381fec825435c836edbc29"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
