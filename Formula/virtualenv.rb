class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e7/32/925d0ee72929865228d5160ec86c7967aea3f7f257f6f2226fcf08cc2352/virtualenv-20.20.0.tar.gz"
  sha256 "a8a4b8ca1e28f864b7514a253f98c1d62b64e31e77325ba279248c65fb4fcef4"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed075a6cc4fd1621dfd4ff59258a17e4f5df7c43fe2ed9b2bb3c73a69e3ab52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7084459ca2b619490c9c36803c55d8acd38ddaa028d54737721023eb1a475389"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d89ceeb5dcb4064ea2152a3401070b3bdf5f8f3f45bfa692081489be2d68924"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c04a44700e6e2c07f9c8c4ea08133c013d0c8ca51bace66e5fd863d4708ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "eed88191ef47e717d3eb236d57d885c351de34d8237a05726b78a7dcac4e0ed3"
    sha256 cellar: :any_skip_relocation, big_sur:        "319a153cff9cf6bbc25c617853246bfc6ff76ec9cc0667e3e236b38698709d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91228fe0eca8d1910350eafffa14b5d379fd51ac170fbec10333646950297223"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
