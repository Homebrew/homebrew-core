class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-1.0.2.tgz"
  sha256 "17575266273fe3f762595fe404f49ff5fbd4c360f605cda0718cb62d65ad82b8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5003c2e4717f5ae3f32a0bc1656a9fdec5a130cb54cec5dceeef497367a277b6"
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
