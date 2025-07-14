class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/ea/eb/8f544caca583c5f9f0ae7d852769fdb8ed5f63b67646a3c66a2d19357d56/xonsh-0.19.9.tar.gz"
  sha256 "4cab4c4d7a98aab7477a296f12bc008beccf3d090c6944f0b3375d80a574c37d"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b7167cd7cc3018619cf91cefdf3c6bcab8182dd32eb211ea172703741f0ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea656e4857c05466be82dffb1ea7a669ff0f667efba6a71a3ed79734995300ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e1ec515cf59d953ceb0914bcff2daeb9dacb152821ea8688225ec77639a8989"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7f93373afa78c8413e5cc53c47509791e3cfa0b8565a1fd7ddc1c4ed669674d"
    sha256 cellar: :any_skip_relocation, ventura:       "f97d813fdf382815065cdae5acf7bcf0f497e93d9423f820af5567e6bc2941b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3c62c2d6622995b724753eb0d26eb8aec3801f7a08a82990504db6a8d1df423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9c1394a5fe80d60519c25f0737dacc8cc2008e2167250f588fabebe316aed7"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/9e/af/56efe21c53ac81ac87e000b15e60b3d8104224b4313b6eacac3597bd183d/setproctitle-1.3.6.tar.gz"
    sha256 "c9f32b96c700bb384f33f7cf07954bb609d35dd82752cef57fb2ee0968409169"
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
