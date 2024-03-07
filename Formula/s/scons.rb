class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/a4/ce/31e6d2f5e1d1cc23d65cfe4e28b2a83cc2d49f4bb99b5eec9240fb9a9857/SCons-4.6.0.tar.gz"
  sha256 "7db28958b188b800f803c287d0680cc3ac7c422ed0b1cf9895042c52567803ec"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "353167afa9a64a00cd898ede3e9aafa5aae93ed15ab2e70d7d115062a776e007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efbb532f51729c66f5f42333144a2e08c6e0ca116be788ab15aea05876dad282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d030e4e92504f0a2474ae6aa05f0fde5348d27bbcf0f069a6d44bdeb11cde45"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4eeee8de9c308cf08901214dcae639d875910dc9e69443476faa12ead3e73fa"
    sha256 cellar: :any_skip_relocation, ventura:        "880782191160aa35640cf2b009c7e0a1d6af08e6f969e898ca93fc6105a55c13"
    sha256 cellar: :any_skip_relocation, monterey:       "fe4e3814e7ed2c04b17326c4d48168276b3a5fa2573d6c3bf5fc3b692375e6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e59f0211787451590668a9790ee7e37da4ef84c293955cf1193e401fc53caa"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
