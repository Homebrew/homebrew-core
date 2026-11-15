class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://ramalama.ai"
  url "https://files.pythonhosted.org/packages/b3/dc/ebce0510d4d78b14eb1f84b4f6509eabd47f6a807dfe28dbc294cf2a7ecd/ramalama-0.26.0.tar.gz"
  sha256 "616a33f35fbd9bb731ffb82fff25ac055c91f1c665f688d19536ce58b1b8a3a4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "26703d5c3012d1e11fc28ae475b92eef041b1d6fb723510c41847e3bfdfa4f08"
    sha256 cellar: :any, arm64_tahoe:       "154393c3bacae9d4b749d0660a86df67bd40d3df7210e7b959553a9adb660cd9"
    sha256 cellar: :any, arm64_sequoia:     "a355f24f277b1595c6758c9c1708f3a33dd6093b840720f6be93dfa0d818926d"
    sha256 cellar: :any, arm64_linux:       "43589bf744ec753bf01a3200eae087c6e48b11b5f0e441746fe85b9687923b4e"
    sha256 cellar: :any, x86_64_linux:      "3caf12c800e7a844afbc8e0fe2189e63fe2dd6aef187eadb104a71eee7e0d320"
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
