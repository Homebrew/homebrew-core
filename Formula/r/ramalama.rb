class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/7a/39/6dab0a0a452e924dfd138ce522fe264bc0623aa44aba047e65f0fc83eadc/ramalama-0.20.0.tar.gz"
  sha256 "5036b600ae2fa5d8a9791ad0109c23c54df812fbdbf9832a076d1a5330abc19e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bad3be09c8ec5c93f8d4f7c6cec9c312c823f83dd655a9274b49b50150c8f8f"
    sha256 cellar: :any,                 arm64_sequoia: "ce73b3cb703b6391eda99362a79f61af15071c52d97d841cb74368b740ac39bc"
    sha256 cellar: :any,                 arm64_sonoma:  "ae6d0e93eae9c538dd6a812ad6e5b5429d9fb6df895620097a822fe9dacc476b"
    sha256 cellar: :any,                 sonoma:        "614768ccce512a692d31f58d7ef7de99204548eb5b55f933873e213f8a7dd33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "557e521374e6a666a84dd6ae6438095962e06bad30c9589c2963f0a1fb828935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf32d32137ea31dddd8e788351d8e74d751ca29cc4acbbec9ac8ba9d2466931"
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
