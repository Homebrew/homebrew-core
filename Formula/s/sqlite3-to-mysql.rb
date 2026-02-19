class Sqlite3ToMysql < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from SQLite to MySQL"
  homepage "https://github.com/techouse/sqlite3-to-mysql"
  url "https://files.pythonhosted.org/packages/7f/a6/a472f84f2df6a604e85cc70d6cad2dca3a392bdd97906afc5958f5802919/sqlite3_to_mysql-2.5.5.tar.gz"
  sha256 "f12165f80d8208ab4c1c668953862d08278fcf65a7aaf39ca99a347eae905127"
  license "MIT"
  head "https://github.com/techouse/sqlite3-to-mysql.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ad06ba9100a13a97b061f981ad180864da3dc7a3b9293fd5f9aa876a3bdb7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4be43dfe556c713e04522cec9e358f9b85b9715a5ff97c87e54e51d788e933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39c43b81d0231eb1dcf3af6542f1f79e36e5a6a3dc723079514fcde00a77e8a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cd5462f97e0d4014d712e4975de4a7e9f6e48180a5ad2efecacbdfd28d8c218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0599cd54ac8844467bbf7fedfa5726c02fa11cdca8fd24fb3342bb91e17bf930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be072b0d8a1e7e989693b13e4fdb3e7bf6be6e1f91a6f43e89c88fbfaff75ff3"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/39/33/b332b001bc8c5ee09255a0d4b09a254da674450edd6a3e5228b245ca82a0/mysql_connector_python-9.5.0.tar.gz"
    sha256 "92fb924285a86d8c146ebd63d94f9eaefa548da7813bc46271508fdc6cc1d596"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/bf/8c/a4d24b6103305467506c1dea9c3ca8dc92773a91bae246c2517c256a0cf9/sqlglot-28.5.0.tar.gz"
    sha256 "b3213b3e867dcc306074f1c90480aeee89a0e635cf0dfe70eb4a3af7b61972e6"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
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
