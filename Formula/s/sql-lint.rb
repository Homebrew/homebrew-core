require "language/node"

class SqlLint < Formula
  desc "SQL linter to do sanity checks on your queries and bring errors back from the DB"
  homepage "https://github.com/joereynolds/sql-lint"
  url "https://registry.npmjs.org/sql-lint/-/sql-lint-1.0.0.tgz"
  sha256 "0ee3b71d812af3cc809829b663d9cd747996ec76e2b3e49fd3b7a5969398190e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40e19503b278a973ee143e996728f5226235886ff2b1a42b08e63715b6ae2004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c41585b38889006247a0d7a66278ba037138d2395321031d0ac899892fa19255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c41585b38889006247a0d7a66278ba037138d2395321031d0ac899892fa19255"
    sha256 cellar: :any_skip_relocation, ventura:        "71d7fcfd2c05ff837511c0599ee227e06ecbb49a4a5dc0166f91e765d239e802"
    sha256 cellar: :any_skip_relocation, monterey:       "56ec39a2f7cd18626231790aaeab98c6f4d7fa648dc6227cd65884dfdddd3d15"
    sha256 cellar: :any_skip_relocation, big_sur:        "56ec39a2f7cd18626231790aaeab98c6f4d7fa648dc6227cd65884dfdddd3d15"
    sha256 cellar: :any_skip_relocation, catalina:       "56ec39a2f7cd18626231790aaeab98c6f4d7fa648dc6227cd65884dfdddd3d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41585b38889006247a0d7a66278ba037138d2395321031d0ac899892fa19255"
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
