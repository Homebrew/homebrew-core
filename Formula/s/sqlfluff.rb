class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/e6/37/6fa8831fad5ffda6e5d3c2629b4c9ed1a4e480b4d8c9f127f132463d6d75/sqlfluff-4.5.0.tar.gz"
  sha256 "0b0d5b2cca03e7d138b8d899249fed5fa54083e407bbd161449c0b30f901b7b8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7114bfdc2fdc087bfa28be10a4e3e6ac37065a2c9d72d07ac96c889757086fd0"
    sha256 cellar: :any, arm64_tahoe:       "b136f8afec98d6daf3393507ea253498631d8e655d6af9edafd28fa15655ecce"
    sha256 cellar: :any, arm64_sequoia:     "b15738f8f9869b22523f4a017707f892a1172d08f1ee6b98198cf84c933ff415"
    sha256 cellar: :any, arm64_linux:       "fcdbe95c01b5d6612ea5cc036cca72ffa1403c05a0f11573dc3ea765b5af341b"
    sha256 cellar: :any, x86_64_linux:      "4567766b32009b0d581240c25098e8d05848f9b93fe3cc73f0019b4e33506aea"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/47/92/3d893ac5d338b9a9af34c5b517d77492dcea8a10254254eead4215a96f3f/chardet-7.7.0.tar.gz"
    sha256 "0ba38a05201b0abf7570c12d8af45c30b2af835bd5cc52bfc7105082eda82c1e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/f5/95/eed8243dd7c3442661c57297b5b1097d463a9d0fdabad5f42200c7ca7548/diff_cover-11.0.0.tar.gz"
    sha256 "5450247cc885ac0c252f0d7a4cf91608f454377c6f88e579bc9ead410af50c36"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/40/28/1c058a9143d2304b3078f8dadcbb9dc27f7d3581b5d05157c84869c4cc0d/platformdirs-4.14.0.tar.gz"
    sha256 "83f009c1e8c5fc36869b5171755b291887bd2cade7965233cdfabd23d754720b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "tblib" do
    url "https://files.pythonhosted.org/packages/f4/8a/14c15ae154895cc131174f858c707790d416c444fc69f93918adfd8c4c0b/tblib-3.2.2.tar.gz"
    sha256 "e9a652692d91bf4f743d4a15bc174c0b76afc750fe8c7b6d195cc1c1d6d2ccec"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
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
