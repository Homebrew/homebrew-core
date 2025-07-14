class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/0e/5d/1afa1e5ec8c4ffe3e0d626ff9ea03c1a0885577fafddba2d15fc7a6ac4f9/ramalama-0.10.1.tar.gz"
  sha256 "8d41850b3e31909161b1fc77fad0cebb7720c5c01496dda69323756c29b38a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0045abc10a488e28ab74d542a84001a9fd26b373b80db6768c5e4124ce0c93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0045abc10a488e28ab74d542a84001a9fd26b373b80db6768c5e4124ce0c93f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0045abc10a488e28ab74d542a84001a9fd26b373b80db6768c5e4124ce0c93f"
    sha256 cellar: :any_skip_relocation, sonoma:        "494e32c3173381cd57d7be497b31952afae471061ee3e9ef7bdc1c13f2c36b0f"
    sha256 cellar: :any_skip_relocation, ventura:       "494e32c3173381cd57d7be497b31952afae471061ee3e9ef7bdc1c13f2c36b0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422f6079908487d8f64292ae65f6152a850d505a555bd2e460537fe743352445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422f6079908487d8f64292ae65f6152a850d505a555bd2e460537fe743352445"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
