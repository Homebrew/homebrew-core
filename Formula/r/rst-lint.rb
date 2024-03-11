class RstLint < Formula
  include Language::Python::Virtualenv

  desc "ReStructuredText linter"
  homepage "https://github.com/twolfson/restructuredtext-lint"
  url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
  sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  license "Unlicense"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db6397fe2d4b35e67f124e9582f3197e28b4932ab113ec4cac2f034cef2a654"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "431cbcd662e20a5e4df5738eb6c6dbb71cbabd450f83daeff704a1b98885d936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eda922bdc79d0b4aa1cab87d7d1f8575b191ee0dd03a9913b667d024dbdc8cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a6b658d2b234bf2278667d39bea343d47511d9f7f72e4d76505384cc093fec"
    sha256 cellar: :any_skip_relocation, ventura:        "975a231fd9109436a7797b5dfd2a9fccd30fd84a1c79c80e4167711ff1b14038"
    sha256 cellar: :any_skip_relocation, monterey:       "daa0ff6cbd83610b8439648ab9648fa6fd818394ca77007f94af04cb9bfe052a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108a99943b09360f91f3e2f45cd3ae287408ec38f17c806c40a84463349b679e"
  end

  depends_on "python@3.12"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/1f/53/a5da4f2c5739cf66290fac1431ee52aff6851c7c8ffd8264f13affd7bcdd/docutils-0.20.1.tar.gz"
    sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # test invocation on a file with no issues
    (testpath/"pass.rst").write <<~EOS
      Hello World
      ===========
    EOS
    assert_equal "", shell_output("#{bin}/rst-lint pass.rst")

    # test invocation on a file with a whitespace style issue
    (testpath/"fail.rst").write <<~EOS
      Hello World
      ==========
    EOS
    output = shell_output("#{bin}/rst-lint fail.rst", 2)
    assert_match "WARNING fail.rst:2 Title underline too short.", output
  end
end
