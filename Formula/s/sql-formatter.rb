class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.7.0.tgz"
  sha256 "9381fd6cfc2ea37e07b978290e94a7e9baa04f2a71ffc7a62a89eb71e4713df9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54c1798301319ba620edceadf7c064aa61773aa84f25ae8485bb6b43a6a8dac8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sql-formatter --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM users WHERE id = 1;
    SQL

    system bin/"sql-formatter", "--fix", "test.sql"
    expected_output = <<~SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = 1;
    SQL

    assert_equal expected_output, (testpath/"test.sql").read
  end
end
