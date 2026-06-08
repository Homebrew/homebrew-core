class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/af/a3/fa28d6db93930f349a7c99774ae7b4b9c85865a780f98ef1ddeb52abdf5a/sqlfluff-4.2.2.tar.gz"
  sha256 "0ee2bcd5d704d0bef56bf80b8f0da9b519ab3e9e0bb1d5e6e4b7e3944d3f5606"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e303b7fc3c79ceb1ab36cb1c903db0f7dc50de84c4c959120b4be731798ec82"
    sha256 cellar: :any, arm64_sequoia: "be70866ce2aac9309887a9032e9fb9aeee975792904bc4028147b4cf2170d29a"
    sha256 cellar: :any, arm64_sonoma:  "9bd67347c7ad0c576273e5226bccdb70e2441c673044fe676d215a7d85c5072e"
    sha256 cellar: :any, sonoma:        "3f374a397b97c2775d98f7be7d76264e88fe534b01260625342b8afebc90716a"
    sha256 cellar: :any, arm64_linux:   "cabda593c83efea1bb9ca842eb9afc5001015c835d18aca4c842cd04579104a6"
    sha256 cellar: :any, x86_64_linux:  "13bf53d89a54b14e1e5c04d8d11b7ff889cd41fde1632ce1f7576c86d8c3d449"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/19/b6/9df434a8eeba2e6628c465a1dfa31034228ef79b26f76f46278f4ef7e49d/chardet-7.4.3.tar.gz"
    sha256 "cc1d4eb92a4ec1c2df3b490836ffa46922e599d34ce0bb75cf41fd2bf6303d56"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/35/21/057e816125c162662d2a2cc2ebcd72dd333e78e51678298d07dd3146011a/diff_cover-10.3.0.tar.gz"
    sha256 "474dbc63e815fbb7567d7b7ca5b104123e96129f25426ebdbc9a1bdbb935b2c6"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
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
