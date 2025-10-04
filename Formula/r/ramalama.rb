class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/08/31/e033911fb8c6332b1f935cfa91bfa9a2ece930e9f7150f4f8008eb9b7427/ramalama-0.12.3.tar.gz"
  sha256 "666ce5a71c8560682a2ec9e83e97597d0d26c201e6b01222ef7d82b46f679ed7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f48f05ebdb266394b5734753e7e61c5be8d1bd083f917c1d91240b58c2531409"
    sha256 cellar: :any,                 arm64_sequoia: "de034fd5d6472781b5da02a25a293ffab58ebafa2342cce098ccc40bfa0dbdd7"
    sha256 cellar: :any,                 arm64_sonoma:  "44f2a8c53a1671357dc6f2c33ec9390195d27ae2010a6b8ad54feea0dd6f0661"
    sha256 cellar: :any,                 sonoma:        "ec16dbf1324aa756c24b3d5143ce38ae81a0cb3464be45604f80101135cae8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f9c38d9dc91be915be76423f55ce0e3496bf23b94e3c3415804cb02702d2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebe3919ff66311b08a46c795198e8bc928e8852e8cfd174f0336c8a4d3ee8d0"
  end

  depends_on "libyaml"
  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "TinyLlama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
