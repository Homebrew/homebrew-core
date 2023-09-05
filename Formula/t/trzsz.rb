class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/33/14/5b54b20f4027f23c4dab039a3ac2c73df2b79039c449ebbe2903c98c20e4/trzsz-1.1.3.tar.gz"
  sha256 "4d38e35c128ef86a350bead31cc754c7bbf33ea323d8050ea7ef7d81caf9595e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23f1f3bbcb09a8fd40f8aa2b3bccf7ccffbed8499fcbfe39010808262b75db00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cfd5f8c76416c5621dcfcd9601118e4f355b2efc363dd4f0e343610f4c59dae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7d38c446d62110bc2d5083530a856446d763dd3cac57078b01c073898676be"
    sha256 cellar: :any_skip_relocation, ventura:        "ecfa341ac34e13d455cc79b641cca9897fd48f8838de639cf1abb7a3527b1d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "3c142278be05fd16fecbb6d88498ff47ad36b493ebe9df24069806ff84b3bd41"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b23e8d8628a69bf4646ea779a9b4459dd3d92d93b696c20dc31ec70bbe571a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0d119728b028fc04da77460caa7b93059a5ce3a75c00a13416dd53044a8003"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/2d/e2/ef11908cb52c1a66b751c7615c7a62aeaa2ca1c13594fcb8bac4403ce4e5/trzsz-iterm2-1.1.3.tar.gz"
    sha256 "6910e413e65efc14a938a04df7fde5d8c5090f343e572c71e00ff32335fc326f"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/9d/7e/59ccff82d9fc525d29721e3e0acd4d3bb0adc9c56e6e56a506009800cba1/trzsz-libs-1.1.3.tar.gz"
    sha256 "dc64e9cfcfeb23ca406932c89755e1141d443c54795eed0d15cec5581de2fc9f"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/65/ca/febf965d861a7766fd93349d91f73892abd78b28b30d8ad97b540d1ba07c/trzsz-svr-1.1.3.tar.gz"
    sha256 "e994511688a62b16ce8c1b28f7abf782bccfd8a41728456ba58b5e7fef970c79"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
