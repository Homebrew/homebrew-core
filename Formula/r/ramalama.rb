class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://ramalama.ai"
  url "https://files.pythonhosted.org/packages/ae/84/31d8f4f2edc2b03d4737b428bfa2af860561cde175938c6165a666b15dee/ramalama-0.24.0.tar.gz"
  sha256 "7dae773274d8eb2cc9363cb5cebc32abe1730d278efc337f980b183a7caa6f5e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d5c668e737ddc3025b853e5853c0102cf29a6460b37cdf7bfa9d1f8c09e7200"
    sha256 cellar: :any, arm64_sequoia: "7da81e9d6bcafac1759a6cdaaa208cabb53743b10438fe96eac610ebb167ece3"
    sha256 cellar: :any, arm64_sonoma:  "5164b2a47f896717b24dd7d68916a2d066b8266d0826336120efca8f7c953d20"
    sha256 cellar: :any, sonoma:        "7b8197e4ac87e8f8094914aec7cb1f401fc38a6895a16bd5fad92014f40deb36"
    sha256 cellar: :any, arm64_linux:   "11011a2c455a78d2c9ce76442a95ed8fae68f27c42a2c9c409db6b18398203e1"
    sha256 cellar: :any, x86_64_linux:  "64390644c66a4ad7dc0bd0d0bb983bd32aa41042f5e24674ae1ace070c46da9e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"
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
