class Visidata < Formula
  include Language::Python::Virtualenv

  desc "Terminal spreadsheet multitool for discovering and arranging data"
  homepage "https://www.visidata.org/"
  url "https://files.pythonhosted.org/packages/aa/c0/ab9f01fcacbfbacde960e143f7c168c4de3c4f7e450873f8fd96fa2fcfb3/visidata-3.3.tar.gz"
  sha256 "a94f4e398477e038541849cf4df1d1f2efc399da544d77db189bdb7f2fc014c4"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8be7f319d1633fce26ef5706d96174cf42244bea0f88da6114f7e5cf0ac9c962"
  end

  depends_on "python@3.14"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "standard-mailcap" do
    url "https://files.pythonhosted.org/packages/53/e8/672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75/standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  def install
    virtualenv_install_with_resources

    man1.install "visidata/man/visidata.1", "visidata/man/vd.1"
  end

  test do
    %w[vd visidata].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,42
      Bob,34
    CSV

    assert_match "age", shell_output("#{bin}/vd -b -f csv test.csv")
  end
end
