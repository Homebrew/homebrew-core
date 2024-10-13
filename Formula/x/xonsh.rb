class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/73/82/c39c24a07daf22877f2ffa0c53dca5cd7c84ccc2d647b6fd6cd134d7f022/xonsh-0.18.3.tar.gz"
  sha256 "e57630d3f7e77e083618751402bf486bef51d2c42ed2abf3e0f4db388a50795f"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da686b755b2ffda91e301e88cf9f7484d2b4bf3a74a245eb5c6e240c868efab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88064d38089fa20a7a9c9bc1c311053e49105de2c588642c58bc2b53ca67e399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4051cbd7e21ae4e4d7713b1b7c53a0f731d915964508672c0257cdfa9cc4446c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d930839c027d8def1c3073d1fd00cb8570e6a459577db30f4c792cc9b10a7c0"
    sha256 cellar: :any_skip_relocation, ventura:       "75bf6a8bf3a21da757555ed499725d44e7301ba2c9c8f15adef803e7f5fe0623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa43b09723358a66997be25e1ec39cdcc1f13ed3cfbf8fcd05825692b837a16b"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/2d/4f/feb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127/prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
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
