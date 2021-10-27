class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/21/d2/f5194c2d51b2aab4bda6de97c5eb1ca5a547ad9b9f778ab5bf4ce19fba88/thefuck-3.31.tar.gz"
  sha256 "6e6083e6c94fe948fcb9c6083baee30ba4cf3f09ffd30cd9564d6473db271941"
  license "MIT"
  revision 1
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6e1b84afcb1b8cb97bfe27607860b9c9ea1625d1d96adf784bd9f92c1268b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7246194bfb83392fd64bba4abb52121c909457989178c48bdeb4a1f2131eb982"
    sha256 cellar: :any_skip_relocation, monterey:       "ec984854e30a8b7055f2cb3d93e8298f1b4b26447bec8d98e246298daef50d23"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6ff31e6acd33cc8693ec64f77b64ebd5214798602ea897ae0e73de6369a717a"
    sha256 cellar: :any_skip_relocation, catalina:       "3b6da25b50f07e16fc8b178182eaedf4258cdb27ee7bde746e8d7c91bf79790a"
    sha256 cellar: :any_skip_relocation, mojave:         "a1d299b1561cae8e6282658f378aa77e9dc4bb8b2750c07af74bab5a1510ee4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe88c05c5339f3eb6d1cf31b56b2555184b2c041ab503ca946f21f1ccf09f4b"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/4f/51/15a4f6b8154d292e130e5e566c730d8ec6c9802563d58760666f1818ba58/decorator-5.0.9.tar.gz"
    sha256 "72ecfba4320a893c53f9706bebb2d55c270c1e51a28789361aa93e4a21319ed5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Add the following to your .bash_profile, .bashrc or .zshrc:

        eval $(thefuck --alias)

      For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"
    ENV["LC_ALL"] = "en_US.UTF-8"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match "TF_ALIAS=fuck", output

    output = shell_output("#{bin}/thefuck git branchh")
    assert_equal "git branch", output.chomp

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end
