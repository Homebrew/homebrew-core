class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/2d/88/ce119d3090f2293b0e900f9eed31bbbb0138a2a392f2d1650ab7f526bd9e/xonsh-0.13.3.tar.gz"
  sha256 "f4cb0b9900943acf224e690ade3db670581dd1ce8e2e1fab9ac80ed516259a94"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c7d25d687f8a0c2b3e4edbc14c354deb3c48ef9ce245126ab3ba83bb0aed22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94623f130a3c31cea0bd198617a688cfc5baa4908d8b0b88a163310ba9bb4182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d40e283b8f3226a33e42ee7c794deec1c15765355d9610e81dcccfbec851ffb"
    sha256 cellar: :any_skip_relocation, ventura:        "1365fde44d0e5a2378bf38bde97ed81ec69ad7b1bbf9dda413547c219557f0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "ce0fb281461a5068377d51b7ace0f4924a70c79314dc29836af75ef78b5bb999"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6ba23882117c378fecdd7b2589db9d18039ee54790863a5c37dae29e88fdd27"
    sha256 cellar: :any_skip_relocation, catalina:       "76eb9d2f0f13a7db8eac712b8c48dc4413586e72e4ee3553fae3a81fb05a8a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d1326a38df76bcc4353cc56222520aa39ce15f805ce404d7228862b85ab5fe9"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
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
