class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-1.0.0.tgz"
  sha256 "0ee3b71d812af3cc809829b663d9cd747996ec76e2b3e49fd3b7a5969398190e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4b460da40ab03af6d48fa557a567c21d06d3e5cc3718392d7daafd9d89e922a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2365c7675f29386b8de28968310fc9dbf242c59f260ed552bc249854b41396a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2365c7675f29386b8de28968310fc9dbf242c59f260ed552bc249854b41396a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2365c7675f29386b8de28968310fc9dbf242c59f260ed552bc249854b41396a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "73b4fe6c09ec7143938b2c938dfebc764c86063ed2eaa593c028c69003ce7b84"
    sha256 cellar: :any_skip_relocation, ventura:        "73b4fe6c09ec7143938b2c938dfebc764c86063ed2eaa593c028c69003ce7b84"
    sha256 cellar: :any_skip_relocation, monterey:       "73b4fe6c09ec7143938b2c938dfebc764c86063ed2eaa593c028c69003ce7b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "64adacdf846ce16c5cca8c70774584882c78ce16625a685eda7802f56b415cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8391c3cdbf4c3876e3c7a88978c03ae3fa8ef53fde71ce9e04faa59511af14"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"pg-enum.sql").write <<~SQL
      CREATE TYPE status AS ENUM ('to-do', 'in-progress', 'done');
    SQL
    assert_empty shell_output("#{bin}/sql-lint -d postgres pg-enum.sql")

    (testpath/"invalid-delete.sql").write <<~SQL
      DELETE FROM table-epbdlrsrkx;
    SQL
    assert_match "missing-where", shell_output("#{bin}/sql-lint invalid-delete.sql", 1)
  end
end
