class Visidata < Formula
  include Language::Python::Virtualenv

  desc "Terminal spreadsheet multitool for discovering and arranging data"
  homepage "https://www.visidata.org/"
  url "https://files.pythonhosted.org/packages/d9/1c/df4179d28dd544646e643e1608cb1dd54ffed6cb00259880e65617452273/visidata-3.5.tar.gz"
  sha256 "0ed3d90688d5310664a728446afb8e5ff4ef366aa71fb1c75d0002fa1170bd81"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b214353a03642fa1a91a7315500e026fa5d7084edbd8f185a54ae094c9699c0"
  end

  depends_on "python@3.15"

  pypi_packages extra_packages: "openpyxl"

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/d3/38/af70d7ab1ae9d4da450eeec1fa3918940a5fafb9055e934af8d6eb0c2313/et_xmlfile-2.0.0.tar.gz"
    sha256 "dab3f4764309081ce75662649be815c4c9081e88f0837825f90fd28317d4da54"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/df/f15f80383f152452d8985b36d95cb8751f901a3e0ff4cd27f7e118f168e2/python_dateutil-3.0.0.tar.gz"
    sha256 "7ebcb3c29a92f3ceafe79a7a48a5c45677e9e004bbeec5742ac0bbb00560b7a2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "standard-mailcap" do
    url "https://files.pythonhosted.org/packages/53/e8/672bd621c146b89667a2bfaa58a1384db13cdd62bb7722ddb8d672bf7a75/standard_mailcap-3.13.0.tar.gz"
    sha256 "19ed7955dbeaccb35e8bb05b2b5443ce55c1f932a8cbe7a5c13d42f9db4f499a"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
  end

  def install
    virtualenv_install_with_resources
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

    # Verify xlsx support (openpyxl) is available
    system libexec/"bin/python", "-c", "import openpyxl"
  end
end
