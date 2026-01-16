class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/ad/a1/2da93b1a7abdac61ef06fc343723c9449400f3ad25cc776b5ff3eeaf7d95/xonsh-0.22.1.tar.gz"
  sha256 "99db059725dc7061c1647099fe8ce619ba2ce520018606a2f7a720032622a9b5"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1953e9a6eec174a4d59c3155332d079201b09ccd54f3e0d1320a908913b46f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec480c410ebd902de5e5e7b17144924a6f3a439d1a5ea7b349811c6632e833e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "150ac6d05dc6c93029f7ffb05ab8723e0d93262b64190874221e4fcc86ee7a06"
    sha256 cellar: :any_skip_relocation, sonoma:        "90146653bd73d31ddde2dd52e45a48cbf84c995c956ee998b947a3128da2fd6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a26f9f9747f9819f4b22246b852d3ddc936893995fab0c640001215156e2155d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98c55f0e71c264279d0db49b026185fd66b3efbbb89f117f68268745dd37323"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
