class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/d5/c1/ffe7b97441b8a6febfb8288226344898944fa2007e93779607096e8bc93a/sqlfluff-4.1.0.tar.gz"
  sha256 "83dd4c081afb48c0af861833015a18b13d52726bfe52a286246dbd7a64b7d111"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f8604fc3964321585d6c2bcb5ba8af5b532d743d37d00c5faf47f64f56371d0"
    sha256 cellar: :any,                 arm64_sequoia: "93668c34bf02b64e52437645df2dc3a4f5c80ba7617e897ed3125d06def62942"
    sha256 cellar: :any,                 arm64_sonoma:  "38636d0bffbee05f4e522c34a54d326b95d220ac46c57bc42aef3b3311cf6048"
    sha256 cellar: :any,                 sonoma:        "abdef0b816649599c097ebb19d396f61a04fbdcf303cac9ba8d4bf5d9e77eddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c03f0951fe8c10b757932a4f8e086cc01f2f074fc6abac6dc3b71e03e799d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9994a780649afb39ebe45025473c980327efbee4a5a3178d6e7f08cf09227e37"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/03/4b/1fe1ade6b4d33abff0224b45a8310775b04308668ad1bdef725af8e3fcaa/chardet-7.4.0.post2.tar.gz"
    sha256 "21a6b5ca695252c03385dcfcc8b55c27907f1fe80838aa171b1ff4e356a1bb67"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/99/b4/eee71d1e338bc1f9bd3539b46b70e303dac061324b759c9a80fa3c96d90d/diff_cover-10.2.0.tar.gz"
    sha256 "61bf83025f10510c76ef6a5820680cf61b9b974e8f81de70c57ac926fa63872a"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/72/34/14ca021ce8e5dfedc35312d08ba8bf51fdd999c576889fc2c24cb97f4f10/iniconfig-2.3.0.tar.gz"
    sha256 "c76315c77db068650d49c5b56314774a7804df16fee4402c1f19d6d15d8c4730"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/d1/db/7ef3487e0fb0049ddb5ce41d3a49c235bf9ad299b6a25d5780a89f19230f/pytest-9.0.2.tar.gz"
    sha256 "75186651a92bd89611d1d9fc20f0b4345fd827c41ccd5c299a868a05d70edf11"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/81/93/5ab3e899c47fa7994e524447135a71cd121685a35c8fe35029005f8b236f/regex-2026.3.32.tar.gz"
    sha256 "f1574566457161678297a116fa5d1556c5a4159d64c5ff7c760e7c564bf66f16"
  end

  resource "tblib" do
    url "https://files.pythonhosted.org/packages/f4/8a/14c15ae154895cc131174f858c707790d416c444fc69f93918adfd8c4c0b/tblib-3.2.2.tar.gz"
    sha256 "e9a652692d91bf4f743d4a15bc174c0b76afc750fe8c7b6d195cc1c1d6d2ccec"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlfluff", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlfluff --version")
    (testpath/"test.sql").write <<~SQL
      SELECT 1;
    SQL
    assert_match "All Finished!", shell_output("#{bin}/sqlfluff lint --dialect sqlite --nocolor #{testpath}/test.sql")
  end
end
