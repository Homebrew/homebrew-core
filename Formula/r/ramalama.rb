class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://ramalama.ai"
  url "https://files.pythonhosted.org/packages/75/3b/840e5bd99acfbb5bf6e7072e2faf2e161fbbebb9e2218b4abb34ab16ace1/ramalama-0.23.0.tar.gz"
  sha256 "dc02b82e46ddd682cb1019c5d474c1caf48a38ca13798d6e92aa3b779e04ef04"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "73211ef33a3bbeaf898c53d60f3461a0bfe62bc6771e82454fad89dc45536017"
    sha256 cellar: :any, arm64_sequoia: "67f9794e138daacd21d49e26586e97eaa1c8fdb72b0a86242814f548951acb8f"
    sha256 cellar: :any, arm64_sonoma:  "1ac49f13114b1738fc6ed3b9428d046c3fadcc9132f3a4137a973b64057e9799"
    sha256 cellar: :any, sonoma:        "2279ea613f69fba32bce427f7e9496342e516be6a6250b9fb650ce90d805d135"
    sha256 cellar: :any, arm64_linux:   "b2b06837dc38e323dc8decb31c2f3b3b3dccc063d002da52fa36c05d3692d2c0"
    sha256 cellar: :any, x86_64_linux:  "a0bb12a96c35c862f9c384a098efc975e8129e601046321dd96efdb54b697243"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_macos do
    depends_on "llama.cpp"
  end

  pypi_packages exclude_packages: "rpds-py"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
