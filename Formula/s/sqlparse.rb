class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/50/26/5da251cd090ccd580f5cfaa7d36cdd8b2471e49fffce60ed520afc27f4bc/sqlparse-0.5.0.tar.gz"
  sha256 "714d0a4932c059d16189f58ef5411ec2287a4360f17cdd0edd2d09d4c5087c93"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "ee42af947580da7a99717c7bd97ddf384ad28691e5e3e7849fd7e4aa5b884bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d20223df7fb8a57b7d2330a4dbe6c8930cce48ade3c999932d8f91c29141d9"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
