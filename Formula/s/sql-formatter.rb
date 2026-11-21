class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.10.0.tgz"
  sha256 "905eb4fbd22a65af0935ae00f7fc6d6713e36fdd96ba0f0d27a3774ddddc46e2"
  license "MIT"

  bottle do
    manifest_sha256 "482a0d0bd91c0c8122c1b60b4387aa43be7449b63879055d0308160344f89c71"
    sha256 cellar: :any_skip_relocation, all: "09d5f11ad3bfb06deddd68a1808c6a7db5a8c70b1df812ab6982fe2090cf8ead"
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
