require "language/node"

class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-0.0.19.tgz"
  sha256 "af38df9ffdea1647fa677b1fae1897c91c787455b1be8654f07c6866da09798e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40da4a973168157d013437dd3c1dd200d3bd020db9377fc6f5eb1af81a0ad61f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "913a8c82424f7f0795cc2acb9a207d915e7ce41408324dcd0f1035bc4144dd9b"
    sha256 cellar: :any_skip_relocation, monterey:       "e7859c895da619aa57a318bdc528d5b5a6513240e86a7048aa98a2c5a790a1fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a7c08631d9f1d905fb44fcf587cee1f9e947b682695f4f698fa42b76d7acc6c"
    sha256 cellar: :any_skip_relocation, catalina:       "8a7c08631d9f1d905fb44fcf587cee1f9e947b682695f4f698fa42b76d7acc6c"
    sha256 cellar: :any_skip_relocation, mojave:         "8a7c08631d9f1d905fb44fcf587cee1f9e947b682695f4f698fa42b76d7acc6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"pg-enum.sql").write("CREATE TYPE status AS ENUM ('to-do', 'in-progress', 'done');")
    output = shell_output("#{bin}/sql-lint -d postgres pg-enum.sql")
    assert_equal "", output
    (testpath/"invalid-delete.sql").write("DELETE FROM table-epbdlrsrkx;")
    output = shell_output("#{bin}/sql-lint invalid-delete.sql", 1)
    assert_match "missing-where", output
  end
end
