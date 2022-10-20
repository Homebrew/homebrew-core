class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ac/d0/0c256afd3ba1d05882154d16aa0685018f21c60a6769a496558da7d9d8f1/thefuck-3.32.tar.gz"
  sha256 "976740b9aa536726fa23cadc9a10bf457e92e335901c61fcff9152c84485ac3d"
  license "MIT"
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92a5cd4630e6a431304769e37202556bdc5d94f2269bf7f2f5b80a2565f3ae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d68b63e488404c565c73c2e77748755bbd900936903ab7b2d831d8dd764e2afb"
    sha256 cellar: :any_skip_relocation, monterey:       "0392109ed68bfd0ebebe81162b16cdc476b3b49e9e29cdf1fa24a5a60f8ace56"
    sha256 cellar: :any_skip_relocation, big_sur:        "7021dfaabb8803611d86df3a7fa3f269fdcd9f0f262c33316273e049cad9e62b"
    sha256 cellar: :any_skip_relocation, catalina:       "9d52203411178d369a1dd9cde5ca2d12bc83092c16041ee4067dc2dbfbcf5791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc185307fd0f02fd34d44a1469a8904d0d4fe59312fde17999746e2640bd6581"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
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
