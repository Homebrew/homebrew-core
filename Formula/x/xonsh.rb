class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/f2/72/478183446101120a8ec1544d8611e5b47f2a0469745dd5e511dc367942d4/xonsh-0.14.1.tar.gz"
  sha256 "81dbf5b5d4d23fe780c7ee5b4ded4f41239e8a8945b1742bf77ee030bdf9f9e5"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d42e2ca14aae41731ac3b9288437288f54d7958261345fd3d4452ea53e85423b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c19097123e4a028dc86b05f5951bd6f895d4f7b77709dac413d5b5cb3e1cf0b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e249a5adc4edd4b7ba3b92616276909ef24301c541690ab439a69ca1ad3f3c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "aee1d059f93d0d448c552747fa7b76348ca999963941554e8ba22aed6b13ed33"
    sha256 cellar: :any_skip_relocation, ventura:        "84186d85a66e8c53795cd9cd48902bef0501889e90246ae8d828f14da813fe02"
    sha256 cellar: :any_skip_relocation, monterey:       "365e25d76ab9fade6d1f78309fe7bfe3ea9d5ffaf2338d356501ed146bd5e601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7955d9d80e3ef3b5bea7cd79a95fd6c07759c3414c5e43c168654dcae6feaa76"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
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
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
