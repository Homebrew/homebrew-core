class Topydo < Formula
  include Language::Python::Virtualenv

  desc "Todo list application using the todo.txt format"
  homepage "https://github.com/topydo/topydo"
  url "https://files.pythonhosted.org/packages/ca/88/48f2fcd7a0c7c62676eb1df8ea2ac2fcaa388614beaf63077472005d44ef/topydo-0.15.tar.gz"
  sha256 "4e466c33934b4ffe48ee3c65347799276adc47b3010fb617bf8b8693473f8799"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b6969f8adb29ce8988ecebf3643dbf48cc01c4e6e979295f634803604e0613d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "301c37f5084e65866d3db3cf88697aa5d27019b16e2316f4a64f581cc9efb2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c7fff3dbca0f0e713440c448a38513146dd323a441fec8fd53de7061af0917"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1aa56eb1b5f125dfabda76cf2139dc13d54487ff78bb2d0bff4ab25cbb6f88a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7097c9179591dbbf690d067816c3afcff533c4e5ed72f8bb69254d07710436ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7097c9179591dbbf690d067816c3afcff533c4e5ed72f8bb69254d07710436ec"
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
    url "https://files.pythonhosted.org/packages/bb/d3/09683323e2290732a39dc92ca5031d5e5ddda56f8d236f885a400535b29a/urwid-3.0.3.tar.gz"
    sha256 "300804dd568cda5aa1c5b204227bd0cfe7a62cef2d00987c5eb2e4e64294ed9b"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
