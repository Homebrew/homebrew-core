class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.7.4.tgz"
  sha256 "c844ac53f813cdb555ca57772c64d4bce643e0175adb6ade2c2ed4cbfb4787ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d94b8323207d7d809056008761ae0244eb146ad509b2afe3bf176aea8020891"
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
