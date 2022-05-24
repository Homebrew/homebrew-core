class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.13.tar.gz"
  sha256 "3ef2dabb47403ddbbdd5d6c48f73e00f7e9db45d2581e6991231e0492633a811"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d8c26c177dba3904884314de2ad823e1981e79a7f57063af722e5aeace91dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "568f764ffff0b7ee1cc8675943c3d139a80600a4c3e8ceeaf91b17a1551da2a7"
    sha256 cellar: :any_skip_relocation, monterey:       "bed00d7a571260b707384660f8701793e1d18a15211d3e730f82196419042ade"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d10e9be7df2d5a01761e4f2a60b9d4eb521c81ef34efcf2d4cdb8ecb958bfb0"
    sha256 cellar: :any_skip_relocation, catalina:       "e9bfe1d2b6b14177b4214860b274b254324920ed4a6385d4d23f79e689eb750a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48954a5a477c2d253afa68a0dea041f6071ddd67785fc67abed0af2e13f7ab27"
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
