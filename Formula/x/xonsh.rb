class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/4a/5a/7d28dffedef266b3cbde5c0ba63f7f861bd5ff5c35bfa80df269f61000b4/xonsh-0.19.3.tar.gz"
  sha256 "f3a58752b12f02bf2b17b91e88a83615115bb4883032cf8ef36e451964f29e90"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "212e3ac1cbed6411752019fccb36661194d7035104ead4c2d56925221db2ecb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58caf5480641341a5a1b8f1ce4a121ee0e87efb86765001c661b306978eb47a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "272c475da0888539e6eebb9c3162286c77f34755324fbd352d55a0ae91adc4ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "687c31bc390db348e5f9641388e026404697ae0e213bddf8ad9fb51e2554c5c1"
    sha256 cellar: :any_skip_relocation, ventura:       "07e190aa8a62386e4bc929d041efdc75db0b710d4f1db5dedc1c94432f55463c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b94e2ec721c85e7e699262400da8644f4624ae539c008782a3ebd6c122605900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5600cd2ebd22f95e8257cc56b8081505e195cb58d2d523c507107c8223d62cbd"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/c4/4d/6a840c8d2baa07b57329490e7094f90aac177a1d5226bc919046f1106860/setproctitle-1.3.5.tar.gz"
    sha256 "1e6eaeaf8a734d428a95d8c104643b39af7d247d604f40a7bebcf3960a853c5e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
