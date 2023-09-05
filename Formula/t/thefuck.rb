class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ac/d0/0c256afd3ba1d05882154d16aa0685018f21c60a6769a496558da7d9d8f1/thefuck-3.32.tar.gz"
  sha256 "976740b9aa536726fa23cadc9a10bf457e92e335901c61fcff9152c84485ac3d"
  license "MIT"
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0de3ebd0766c538d124f74270a91730c8e3e083656e61f09b6e3edb837caf0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c20013e623b39c5bca1fd71e44b200f7e31a2d7f5a377bc92b4593f806aff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d94b1731b44013b526e005137ce28d06484966c41b99e20003d5d40fbbc753a1"
    sha256 cellar: :any_skip_relocation, ventura:        "27254159fefb93d553c8f2941396061950c946354350bbac1d98396fb5771ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "ac8a42c8a3f407106e49da365beaa4f03337e025907bcb69812d28cf1c66850e"
    sha256 cellar: :any_skip_relocation, big_sur:        "788c8f21aec08c8df7cf09ca2be2b5069657af6e9dd1476b7d3b675451549976"
    sha256 cellar: :any_skip_relocation, catalina:       "125e506e6b470358180f6fe49cb45aa99617442a1649fb7a9db18c8aafbd0c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa50d5f202ecb6c751b1f8da9c2e943992bfc182bb6dfaa8b4ffdb46514e0225"
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
