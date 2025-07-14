class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-1.0.2.tgz"
  sha256 "17575266273fe3f762595fe404f49ff5fbd4c360f605cda0718cb62d65ad82b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc63ba9d01196aa966e93b34c8e644c0c6c3471f6c4c3b91e5166e358352945e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc63ba9d01196aa966e93b34c8e644c0c6c3471f6c4c3b91e5166e358352945e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc63ba9d01196aa966e93b34c8e644c0c6c3471f6c4c3b91e5166e358352945e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e49729434ac8f859b1d58793b6042ff6bc9de62f8db6ee8d11759d614ac4ba1"
    sha256 cellar: :any_skip_relocation, ventura:       "2e49729434ac8f859b1d58793b6042ff6bc9de62f8db6ee8d11759d614ac4ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc63ba9d01196aa966e93b34c8e644c0c6c3471f6c4c3b91e5166e358352945e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc63ba9d01196aa966e93b34c8e644c0c6c3471f6c4c3b91e5166e358352945e"
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
