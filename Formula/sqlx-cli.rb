class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.6.2.tar.gz"
  sha256 "d8bf6470f726296456080ab9eef04ae348323e832dd10a20ec25d82fbb48c39a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5944f40403fe859dd3fb9c73fa62575c10a7b0af0d6e83cb2c0c8a4467b88ab7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07477a8f59df5b0d493dda7f73f7963ad383929614284ed1e9c765aab55cdfed"
    sha256 cellar: :any_skip_relocation, monterey:       "b565e2727613c0bf49f1e17b94dbaf0cb3ff5cfe27462442d6700c1f76a72e53"
    sha256 cellar: :any_skip_relocation, big_sur:        "4549e191d8c2a43562c7652d3d2e13c3f729740395c86e2a4df8f0aa4420ab67"
    sha256 cellar: :any_skip_relocation, catalina:       "312cba48f43acf093b74233da22de93dc23bdecc9a5a58ea4e7d099236acb143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e738d40b5010aa2b68361d4d4d2263067d123a591c36f2ff38b7724a3185220f"
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
