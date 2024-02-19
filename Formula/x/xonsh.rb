class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/44/d4/e3f8e6db5db554a6318690acdd5b93f973a625f8fd36008f826f042a910c/xonsh-0.14.4.tar.gz"
  sha256 "7a20607f0914c9876f3500f0badc0414aa1b8640c85001ba3b9b3cfd6d890b39"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c457b22d0982d8777b1e08521c2d65c3dff81259822551d4fd903abeddac4b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "250c4b92b1ad022ef21093b839a6d0def1bf0ff4329cae4903c5f466c49e0341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c572b4ebb7c0cbbc6e88306ab9614fb535cc39b4efff3f85763a1f5a2e3d04c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "90c81a72508f74d2d99613d55cfc34f2af50e604263ece751028caf5a53d28be"
    sha256 cellar: :any_skip_relocation, ventura:        "25a3d8200c626fc92ec518f26b4b25e055cbf6ae493e2df6bc8cba1711637859"
    sha256 cellar: :any_skip_relocation, monterey:       "5849de0bf2794c768b3f13151f484fe02738a385b6bce27c0393e26dfa9981f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dfc7d305c204be43642bd89775e6bcc7e7a8a31c2046a67aaeabdec69814c25"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
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
