class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh"
  url "https://files.pythonhosted.org/packages/35/e3/b0632485c281227e04f6d0fd215df09cf37d7eee247928f1dd7e14a4dc4b/xonsh-0.25.0.tar.gz"
  sha256 "87949263855c7b5338092c57b573ee8b959f001352a5631f98cef413995d5c7b"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6bef787c86b4d3c103522ecbb59e9ef54fc8631a659ddd9888097e49cc75b6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "733875464be2647887d2dc800dd5413305ff98b02faf478f88713cb44d64e9c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4191aaaacda7249c6d7a7ef81ff568023caccd2f9d639f9aec0f5a3ed8989075"
    sha256 cellar: :any,                 arm64_linux:       "5ce4d5714d3b7091c5484d020f8ece81e8ff497321ebab0b4f80bd8f42ac9317"
    sha256 cellar: :any,                 x86_64_linux:      "0a42afa2f0b03575c5c8ea2d3300b02a69e57a53ac20ac9e7a72766d25ba8b93"
  end

  depends_on "python@3.15"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/69/4a/82d61476a1ccc20d43d0805724c5de4baa4971131a8db1816705ef53fe16/wcwidth-0.9.3.tar.gz"
    sha256 "dfe7cfbd4cb59db9fe0931bd6091ab4a95b3acc5d56bfb50fa9fef0ccba5dc5c"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
