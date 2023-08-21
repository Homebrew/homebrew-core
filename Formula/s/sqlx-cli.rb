class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.7.1.tar.gz"
  sha256 "8e2697e3c8a102234f97e74c2d7c8ec83df2761c14eaf519b6e9302065f4c428"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dde9a1bd9ed20e3395edf73c33e2ea1572c5ee0a82f04058ef7a39065f75ee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b65718af623e94f46c515ea2b93f1c56bbdae6bdf9c188c6754fa830091dcab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5994e742d40958fa3ba2044bca135d721e20ea90bc64677783106f889aa9d810"
    sha256 cellar: :any_skip_relocation, ventura:        "72e6cc892d7379b35f17cd49255638710c6bc502a813c545bf8f9f22038230e5"
    sha256 cellar: :any_skip_relocation, monterey:       "276bf1bce14d2d765792be811c070793fd978160fe66dd6a340c28cd3f74b49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8fe6c26135068f5e0b5817750e8537564ff926f1432cb5a04337c802ff45b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d6e799789af1b3739b5a802bd676a7a0985ac9dd27e70f4cdc5b7ead6535c3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    assert_match "error: the following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
