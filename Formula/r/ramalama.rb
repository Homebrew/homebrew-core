class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/a7/b4/f35697d69a8f0ed26da2f8cb2da8c42cffd19959ea449de3e9fa3cfe291d/ramalama-0.22.0.tar.gz"
  sha256 "90733e64a8d83a1b96d8fc614d0191794e64aba002007a100f4244febb417f3c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26edfe41cb61bee6e36721b617935d89defbce07995d4db039048e6171400829"
    sha256 cellar: :any, arm64_sequoia: "7b378706ccd5129bff1641bf206bb7901c823fe886272864fc80b2f91a8fb00c"
    sha256 cellar: :any, arm64_sonoma:  "503e3b18548329ed7627f5d470a89b8d66ba67728ea32a2e9242d967aeaf14ac"
    sha256 cellar: :any, sonoma:        "8869ef2e2ba921376571912164b657c1aa8836b625a214cecc5d3979f65200f2"
    sha256 cellar: :any, arm64_linux:   "4d994ae18dc5e847d7da44d1879c9c394704f3d7e086b6f3dee54e400cbb50ad"
    sha256 cellar: :any, x86_64_linux:  "65d036288697637c2d4de9a539bd73c6c34e59ea63b39de4b3adb67b6a2c5038"
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
