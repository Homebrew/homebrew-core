class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
  sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ede58d9382d2c4001973c1f70e029f62b795f29a7859ee705e385e404fbb0b57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5731cae98638f788965b0dbe7a616360eb16a08bc5caf24f0b09c643440c49be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2fda30a377f71a235467f81d261a14919c5216436a85c7aa67ceb8285e2f436"
    sha256 cellar: :any_skip_relocation, sonoma:         "3490c40967c3b68169cea6afa3d28f596c817969b9ff723f1b9eac09a6263eb1"
    sha256 cellar: :any_skip_relocation, ventura:        "10f79ac20f585ba3a710fae46cf7c825592869ba01e33dd500be3e7d5a28f8d5"
    sha256 cellar: :any_skip_relocation, monterey:       "dbe0d38a00a72328edd0bc7180c7afa4f64fa547ff538b9b1a7853e2fd717797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e42f080d5a31c1824588fdda09a6f66e659bdd038fdd3f34098a6dec58d4b26"
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
