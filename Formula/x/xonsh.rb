class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/f2/72/478183446101120a8ec1544d8611e5b47f2a0469745dd5e511dc367942d4/xonsh-0.14.1.tar.gz"
  sha256 "81dbf5b5d4d23fe780c7ee5b4ded4f41239e8a8945b1742bf77ee030bdf9f9e5"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b616825a61f1264ca9b63fc704318dce96f3ed9038d720555bcb88792edc2727"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3933275facc6b997169c1aaf579d0971ac8e6107aaec427572ed467b0fe58516"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42515b1f5e3bc81b7b2087513d0e7a9d755e0120168398b0b76816cede950af6"
    sha256 cellar: :any_skip_relocation, ventura:        "510b34598dcb6d125c4ae5a1e74256d69d8acdd424c85d82d8bef1af6c0094e2"
    sha256 cellar: :any_skip_relocation, monterey:       "8eee38ec25d74bd5f685d60bf316fee401e8ab3d308885695fab70b873a90b31"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce32d6c3d335bcb871efc0e41ae58991df226dd770d405f94288d7d58e28852b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9857ea795f4e0a46c79b2f98fe0226be03134080699bce645094e88de42bc255"
  end

  depends_on "pygments"
  depends_on "python@3.11"

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
