class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/48/55/ba8fdbd56c33b0fc7e6e1487b861381a9527fc02b2782caa7317de5fadfc/xonsh-0.13.4.tar.gz"
  sha256 "1075452e6eac9f58c3abf4ad9f38f9b05452e7460536bc993dba9989227a21a7"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7e711795380adc4ba87798b4673ad58e30d74298a90f4a5bfedbad80300b52c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0d08e71602b9882ea6234eb34494dbb8c5654f0997ddc28dfcc6255a8bdd71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5768185108e62abef7faae5e6ae9dc6a060b0c273dcca60e999d81316e1dbab2"
    sha256 cellar: :any_skip_relocation, ventura:        "7db7aea549f1d6614c3da213f85adb2b14945c2edde0e6705a4b0ddc273b21b9"
    sha256 cellar: :any_skip_relocation, monterey:       "13a1d03abeb1149dfa83e7ba4c59115ea69eeed61bb157b5cb9bfa98b59bd9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f7501c07c7f39d5e3d8e8511c6cc5926459a11180d0c37b543ef9b6960ecee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f554276c3ef15bd4eeb885545e2f6c27f5909e809852d908a9e0554c8a688059"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
