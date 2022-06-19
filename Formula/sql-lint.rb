require "language/node"

class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-0.0.20.tgz"
  sha256 "c471ffa379c8b63fd9cfe8e1c04237bdcde6ecead23c34d888dd7e26c057c9eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3c5bacfc2a239ead417154c60476505b5630ad9bd60b13d32faf0cbbd821ab5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3c5bacfc2a239ead417154c60476505b5630ad9bd60b13d32faf0cbbd821ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "52a6ef499d47b9bf02c22d18cf9677ce117b1c8ccf013b080eb6f8ee06728e2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "52a6ef499d47b9bf02c22d18cf9677ce117b1c8ccf013b080eb6f8ee06728e2f"
    sha256 cellar: :any_skip_relocation, catalina:       "52a6ef499d47b9bf02c22d18cf9677ce117b1c8ccf013b080eb6f8ee06728e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3c5bacfc2a239ead417154c60476505b5630ad9bd60b13d32faf0cbbd821ab5"
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
