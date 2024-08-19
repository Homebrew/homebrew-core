class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/64/e8/ea068dfef7a1d49bd947a4a006a9188130bbb7dc08fd5e9fdb426a283cfc/xonsh-0.18.2.tar.gz"
  sha256 "c5073d154f14c210d855aff4863f69ce9215be084ed5562899bdf1c934f7a53b"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b74d3c6e9040bf06043922f3411e3a6ab9c058c25f8c576c72f7bc9fbd4298"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4b44797cdea11d6b329e65c8ef474ef62ac7f89fa08ec2aefdf72550a546be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5ce43b25fbfa0531afc7440c02ec3022bd20364abbe16f37ff062510bb194fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a7bf2cc246aa0ddead1f5e5b741e2a498b5df0e6c42e4395953454360222def"
    sha256 cellar: :any_skip_relocation, ventura:        "cbc8005c8b40f9d8245e9eeaaec03cd4aabc310d8677ca9943c117c7ec83d294"
    sha256 cellar: :any_skip_relocation, monterey:       "74a99ab7e20d9d4c9f4d62b18880c82fad9993df0749dd3c0fcfaf167dc89935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "987ec0aeecf3753b684b918eada854bbbba49301547e031b3ae890753387d89c"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
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
