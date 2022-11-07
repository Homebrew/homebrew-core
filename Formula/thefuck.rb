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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "677b95e5f935e10df2aad28af966120683aac24273362e02dc7341b6c3af6b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92a5cd4630e6a431304769e37202556bdc5d94f2269bf7f2f5b80a2565f3ae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d68b63e488404c565c73c2e77748755bbd900936903ab7b2d831d8dd764e2afb"
    sha256 cellar: :any_skip_relocation, monterey:       "0392109ed68bfd0ebebe81162b16cdc476b3b49e9e29cdf1fa24a5a60f8ace56"
    sha256 cellar: :any_skip_relocation, big_sur:        "7021dfaabb8803611d86df3a7fa3f269fdcd9f0f262c33316273e049cad9e62b"
    sha256 cellar: :any_skip_relocation, catalina:       "9d52203411178d369a1dd9cde5ca2d12bc83092c16041ee4067dc2dbfbcf5791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc185307fd0f02fd34d44a1469a8904d0d4fe59312fde17999746e2640bd6581"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/9f/60/442cdc1cba83710770672ef61e186be8746f419a12b2c84ba36e9a96276d/pyte-0.8.1.tar.gz"
    sha256 "b9bfd1b781759e7572a6e553c010cc93eef58a19d8d1590446d84c19b1b097b0"
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
