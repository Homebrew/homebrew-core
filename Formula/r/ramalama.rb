class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://ramalama.ai"
  url "https://files.pythonhosted.org/packages/10/c6/2487a19773ad71e05e476c3e6df6b78e8ab056270b5b7876a98602f1025b/ramalama-0.25.0.tar.gz"
  sha256 "54daf1cde410347bd0cc7a8f1b8a036a19e8f7d63367d9bc63be8bf4ccc0084b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bf697e4ecb5401a5d2b782c9d3403d3cff247aa107894b9c53fd3156351f9410"
    sha256 cellar: :any, arm64_tahoe:       "153c46f702bbcd6c6a1b2ace9236b037117422a5e15d6a8bdc1663476cd827b3"
    sha256 cellar: :any, arm64_sequoia:     "798aa89bd3143f859b8e4b5ab64dd86ced3c33f413b0d31dfed0e15733f9b11d"
    sha256 cellar: :any, arm64_linux:       "acefe8e15312549e2c23492aacec15cad5abfdd503035da2b021286d3d80b922"
    sha256 cellar: :any, x86_64_linux:      "db702b36769bfe0496ce89943d6b72ef732e6cf4181e5c2ccbcea849a50c5903"
  end

  depends_on "libyaml"
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  on_macos do
    depends_on "llama.cpp"
  end

  pypi_packages exclude_packages: "rpds-py"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
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
