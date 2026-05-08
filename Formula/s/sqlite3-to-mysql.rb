class Sqlite3ToMysql < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from SQLite to MySQL"
  homepage "https://github.com/techouse/sqlite3-to-mysql"
  url "https://files.pythonhosted.org/packages/dd/a3/a39130ba3bbd9ad22ca794fd5ef93b20492474c16879ced76c6b05e60986/sqlite3_to_mysql-2.6.0.tar.gz"
  sha256 "2ac88e1a84fe035c732c83041c1965454bacc5ccf2a52bdb01fb4c5011bd7174"
  license "MIT"
  head "https://github.com/techouse/sqlite3-to-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faeae38ee2074d70a07804c948eb7f40d9d66ab4dd785b8832112510e1e10804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543ac7554387df5e3b0ae768fef6b83679537508b412e199b3e6f3d7805d8d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a9464686122be01e709b2bc6861c591eb7976b580313301291a0996d450375"
    sha256 cellar: :any_skip_relocation, sonoma:        "667f6ec82603d5044d1e7d8d4700a3deed84aebbb3a6577c99ffb8f008b9df24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c06b5e584408a61c02b277d02a0f2ce695bba069d2ff64c78c8a50b623231680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c878d44f7ba91b09853d25ec4ce7114dc5558d71780400bb1e578f16af8ee799"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/6f/6e/c89babc7de3df01467d159854414659c885152579903a8220c8db02a3835/mysql_connector_python-9.6.0.tar.gz"
    sha256 "c453bb55347174d87504b534246fb10c589daf5d057515bf615627198a3c7ef1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytimeparse2" do
    url "https://files.pythonhosted.org/packages/19/10/cc63fecd69905eb4d300fe71bd580e4a631483e9f53fdcb8c0ad345ce832/pytimeparse2-1.7.1.tar.gz"
    sha256 "98668cdcba4890e1789e432e8ea0059ccf72402f13f5d52be15bdfaeb3a8b253"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/0e/2a/54837395a3487c725669428d513293612a48d82b95a0642c936932e5d898/simplejson-4.1.1.tar.gz"
    sha256 "c08eb9f7a90f77ae470e19a07472e9a79ebc0d1c2315d86a72767665bd5ba79f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/3c/66/6ece15f197874e56c76e1d0269cebf284ba992a80dfadca9d1972fdf7edf/sqlglot-30.6.0.tar.gz"
    sha256 "246d34d39927422a50a3fa155f37b2f6346fba85f1a755b13c941eb32ef93361"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlite3mysql", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlite3mysql --version")

    dummy_sqlite_file = testpath/"dummy.sqlite"
    system "sqlite3", dummy_sqlite_file, <<~SQL
      CREATE TABLE t(id INTEGER PRIMARY KEY, name TEXT);
      INSERT INTO t VALUES (1, 'alpha'), (2, 'beta');
    SQL

    port = free_port
    output = shell_output("#{bin}/sqlite3mysql --sqlite-file #{dummy_sqlite_file} " \
                          "--mysql-database nonexistent --mysql-user root " \
                          "--mysql-host 127.0.0.1 --mysql-port #{port} 2>&1", 1)
    assert_match "Can't connect to MySQL server", output
  end
end
