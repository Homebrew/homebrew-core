class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.6.3.tar.gz"
  sha256 "965a6fbbadc88917e37390ba244952c2893f29ca36831dad8c268f6bdf1afc45"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c4cd1259a1c897289e855e44d7daa5f7e4bee6dae43e176cc25c925edc17e3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1efde3edbb42c9b76fedded39666261b4b5d095279e6d0424165245c626470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "671ce41fe5ad478f8d4d487bb04e787cf8bb3ccfdd47eb4f05b1472720b72631"
    sha256 cellar: :any_skip_relocation, ventura:        "35595ec27f1a1e99682a2c274cf9ff80e37eb3cbf1778b21ed50b772771e7b02"
    sha256 cellar: :any_skip_relocation, monterey:       "b27d38431b1a33c3d45a0910b98c0c0c02f2a392690606c9ab9604a8c24f44da"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c49cb0cdc84c846af5558996c961fd0a49738bcf94888b2108934cec13f4a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0aed9ded5bb315407e9749149a447ad7d22553d8d33b6990e964572b06a8955"
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
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
