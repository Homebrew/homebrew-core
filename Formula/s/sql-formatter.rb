class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.9.1.tgz"
  sha256 "0d89de98c4139de443840f00999d0548e6a26036663e77dfb3f8c5b3347fb13f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "741df22ca74d6f046812af5c3dc17012c37d2afc2f27cba9e04db86261683b5e"
  end

  depends_on "node"

  def install
    ENV["NPM_CONFIG_FORCE"] = "1"
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
