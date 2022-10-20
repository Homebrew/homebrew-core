class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.6.2.tar.gz"
  sha256 "d8bf6470f726296456080ab9eef04ae348323e832dd10a20ec25d82fbb48c39a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb71d61259fda5bcca824ff851ee7004123ef8c01a7a2ebbf9795bc0a6f08daa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca30a08522aa469319c807a8ef389299ff2fba06c35520b9dd6d0a79a1cfc4a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d08c7380df1a7c84bfe122f75a3f0e5a1a290337ea22474ac8a293a692573db6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff2bcd344339588c189b8a6375e86778f804706aa5e0df3e0e0ae333b0f8128f"
    sha256 cellar: :any_skip_relocation, catalina:       "27be72ab658f6dd57e2d8ad5c3439f9a42c99586de66b3b0e44dd299eddadc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6274ad415e8863cbbb4e0fccfb7443e10f3a06571e6185ecf957aa3570d1d6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
