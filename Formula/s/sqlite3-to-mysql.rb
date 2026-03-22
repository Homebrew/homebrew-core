class Sqlite3ToMysql < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from SQLite to MySQL"
  homepage "https://github.com/techouse/sqlite3-to-mysql"
  url "https://files.pythonhosted.org/packages/3d/ed/1758693d7005db7fdb09e5db56f245fdce45904bbeb37dabab6f91689192/sqlite3_to_mysql-2.5.6.tar.gz"
  sha256 "f5b615954d59481ff6291d813a138b8a52152ffdfe97337c2997def8f84811f2"
  license "MIT"
  head "https://github.com/techouse/sqlite3-to-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c27548905d04bada36c54239848a758081c6636a7375656af017f78c90dc94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "037aa36412f84f000b6eceba1da50e99b5cd5c5224cc622741166299f27e7671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dfc2b7ffec009ce4af1b09f71b4f63efd2bedb11653f225101b1d6d768a893c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ecad399043145dfcd5bb93cbcbe342cf54f0f797fd269c1265e983df4c68cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1839d49d12ff625b6a2a1c8c7434b413682b87a595a6fb9ff7512fd4f174ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46f95f45ec49a76a90b2b82fd02a857a82dc5060082991eb8b695e8b35f0ccf"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
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
    url "https://files.pythonhosted.org/packages/61/12/c3f7533fde302fcd59bebcd4c2e46d5bf0eef21f183c67995bbb010fb578/sqlglot-29.0.1.tar.gz"
    sha256 "0010b4f77fb996c8d25dd4b16f3654e6da163ff1866ceabc70b24e791c203048"
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
