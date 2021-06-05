class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.5.tar.gz"
  sha256 "4e51566090a23dd5c9e1fabb70f3b15db8e2e25303f3fc9074ae81bfc7e48276"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    cd "sqlx-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "error: The DATABASE_URL environment variable", shell_output("#{bin}/sqlx prepare 2>&1", 1)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
