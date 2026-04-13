class Topydo < Formula
  include Language::Python::Virtualenv

  desc "Todo list application using the todo.txt format"
  homepage "https://github.com/topydo/topydo"
  url "https://files.pythonhosted.org/packages/11/6a/8278ac5a59ec633322dcdff278bf74ce8c9d513370cf41d1ecfa5e0376d0/topydo-0.16.tar.gz"
  sha256 "64a12a990ee39950f0a6e14a5c18e6b35c9e4e4f11cfa40c613d5feb4f086b75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f4329353c1d1fb2e9b6d08296304d03763fe1a3339626fa2aeaaf4d85d09b72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ab91f9a1c6d364941ea3917da7176cd447d496cf37776fec1bd0680aef74b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98b6180f111937e21f5b7b625cda75146db1fe661af6a8687912e2fbc73430bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "996cc264fc9ff19db29b8b7355585a79d9451ca4bb2e73ff0076eac88b35eb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3285119c254079b0d9e1ea4080664c4bc08e7f819734b34544dc8cdef70f8dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3285119c254079b0d9e1ea4080664c4bc08e7f819734b34544dc8cdef70f8dda"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "topydo[columns,prompt]"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/b1/59/67cd42db7c549c0c106d2b56d2d2ec1915c459e0a92722029efc5359e871/urwid-3.0.5.tar.gz"
    sha256 "24be27ffafdb68c09cd95dc21b60ccfd02843320b25ce5feee1708b34fad5a23"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/topydo --version")

    system bin/"topydo", "add", "Install Homebrew"
    assert_match "Install Homebrew", shell_output("#{bin}/topydo ls")
    system bin/"topydo", "do", "1"
    assert_empty shell_output("#{bin}/topydo ls")
  end
end
