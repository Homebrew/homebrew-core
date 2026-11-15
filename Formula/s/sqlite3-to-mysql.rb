class Sqlite3ToMysql < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from SQLite to MySQL"
  homepage "https://techouse.github.io/sqlite3-to-mysql/"
  url "https://files.pythonhosted.org/packages/59/7e/cb1f5f1b238ea0ce7479641144acb7560e5c3564813e6f9f7a58c3529b20/sqlite3_to_mysql-2.6.1.tar.gz"
  sha256 "40fe6b82cb4dad3a3746bade8f3cd843c905b0da5e8663e4ecd00db8911f60ef"
  license "MIT"
  revision 1
  head "https://github.com/techouse/sqlite3-to-mysql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c6e3d9dd0a5b5d29186a3d7a6ef0b63fa0617fccc5400d4f5834323f200b383"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab9ddc4b241fdcf85cb8ecab90b5763b8e50c3bd9a5452070ef1f7375937f7af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfb76d90a33d94b314f2145f6900248db3881969ed36d60be66cc5d4d7d3e145"
    sha256 cellar: :any,                 arm64_linux:       "4959d2adfcc7cde4e4fa975659a1098663efd59f1781baeacd12bbe0a0c379eb"
    sha256 cellar: :any,                 x86_64_linux:      "67b447c420e1624523a24be6b39bce422a8b6b62c65790dc33c1882e1238c504"
  end

  depends_on "python@3.15"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/f2/ce/a53b169388f8c6a595cfa9a653138381f3afef1d2af60f5c1972d015f52f/mysql_connector_python-26.7.0.tar.gz"
    sha256 "d8ff5ee236ea46661ee639336323e124ed868e37f3ea991bdc5de5a146f39fd5"

    # Apply Fedora patch to support OpenSSL 4 / Python 3.15
    # https://src.fedoraproject.org/rpms/mysql-connector-python/blob/rawhide/f/mysql-connector-python-python315-ssl.patch
    patch :p2 do
      file "Patches/mysql-connector-python/mysql-connector-python-python315-ssl.patch"
      type :unofficial
    end
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
    url "https://files.pythonhosted.org/packages/f1/e3/1cc7dbf4deebc16e9dc42db37f473b5b612d021eb10e69974be308425171/simplejson-4.1.2.tar.gz"
    sha256 "6ae4186f90362e9c03c80a1cd5062a20f3a11ac9d391f7ee0ef0701a0e2b7394"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/e4/73/5b5ce3e23b3ded3ea1986c2c2991217460d5fd5161b3e00a8425f5dcb8a3/sqlglot-30.18.0.tar.gz"
    sha256 "e57e1b205e341979d1df5b1212c1435c598a0437e4619e3f428b15d5bc3a5cc6"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
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
