class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/02/e6/4e35a28781b912603aa3f3c4486572af3b3e68d79f2b76243564c7f1d94f/ramalama-0.6.3.tar.gz"
  sha256 "daaa26c7e915bbd6788e70629c27d7e628fded62c534d95270438e724ba4ed05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a832d71a761e74f69cf7111ada507843023b3869666fa234ec973d3420543b4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2018fc643fc16d5a8ec760b43f896a1898f66f861d6b3f481c6233e51ddb9dbc"
    sha256 cellar: :any_skip_relocation, ventura:       "2018fc643fc16d5a8ec760b43f896a1898f66f861d6b3f481c6233e51ddb9dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aef9dd9ab509216691bc48f0e7255d5dac4bc1f5f271029877be63bc559b844"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/ee/be/29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589/argcomplete-3.6.0.tar.gz"
    sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
