class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.6.tar.gz"
  sha256 "1e05f706823563f28b14546694281ffd8d076ba6f48126d152add823984e7dbf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e41d0e307e9d17e8966aed83c29fad8373e82bb9d5a6a3dc6f37a133032277b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "11f11e3eda3869c7cd10e8fd10625f6db88b558e9bc631727dd2b41b6ae6ac7e"
    sha256 cellar: :any_skip_relocation, catalina:      "cbbc676a115e5d2ddf94ec8c78fc83e50898a3189c51079608baa72f039792d4"
    sha256 cellar: :any_skip_relocation, mojave:        "5ce17dc84ca3c80c39e379d2f3e9d7f6bf8d612af07850dc3188d1bfd7edcb10"
  end

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
