class Sqlite3ToMysql < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from SQLite to MySQL"
  homepage "https://github.com/techouse/sqlite3-to-mysql"
  url "https://files.pythonhosted.org/packages/cf/6d/0ebb22477a2098792d3c32532d63698720768fca1d4d0a74df1f6680795d/sqlite3_to_mysql-2.5.8.tar.gz"
  sha256 "fae2d0d7760dfbb7de7b17b24f3ebeb1586cc81f11094b8f388879da6cc6a8ad"
  license "MIT"
  head "https://github.com/techouse/sqlite3-to-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a286e83c99416aca47b10dbfb06b995ed89070e029e1fcd46b627d76c80d45dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957a65164dc50b479b5640a09485741dc63b768d43c9bb6466cc23546fa5f205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768c186ab0ec1ca89e2b03fe87f8f1e651a6ab5d45c2166337e53fae934e1c5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f09cfc4e1a4e5c41fbc3eab057e09a66ca30e60f20299916ccfaaed073688b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ad3ac6686a0f7cc1e69f4975496ef64d0d58274d18b9116ec5888745a86af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8596199e42bb32ff8e58c91faedcedc144f29d9c768e3552ee5ac3dde17517a3"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/6f/6e/c89babc7de3df01467d159854414659c885152579903a8220c8db02a3835/mysql_connector_python-9.6.0.tar.gz"
    sha256 "c453bb55347174d87504b534246fb10c589daf5d057515bf615627198a3c7ef1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
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
    url "https://files.pythonhosted.org/packages/41/f4/a1ac5ed32f7ed9a088d62a59d410d4c204b3b3815722e2ccfb491fa8251b/simplejson-3.20.2.tar.gz"
    sha256 "5fe7a6ce14d1c300d80d08695b7f7e633de6cd72c80644021874d985b3393649"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/ff/5a/b8149963cd479a7e5b71f43d11d678f5e4b8633ab4de5b25e7a5d6eefa20/sqlglot-30.2.1.tar.gz"
    sha256 "ef4a67cc6f66a8043085eb8ea95fa9541c1625dffa9145ad4e9815a7ba60a199"
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
