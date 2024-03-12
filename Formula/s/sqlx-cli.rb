class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "ec388590cc15232eca9d02356428c0527a6cc599d09136fac46f62116050fe77"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "862fef6c7b20c4b93789efe6b1e240ee397f8bbac0272919111486c9f987c5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c22c3ededb8d193305140326250768626c714e38cf9ad3967ccbcdbabc83bf1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb417cc88f9779689db7195e7052a233ed0767e4b420b17102014d666adebec8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbeb66a60dec9c553a434235b3e1b8d35759e762a91ff852ca66db6c10beed0c"
    sha256 cellar: :any_skip_relocation, ventura:        "4f8a91b339fb4ca2a0e3a277e271033e4171ddb3219fa5cd200c45f843d8e9e6"
    sha256 cellar: :any_skip_relocation, monterey:       "13014849852426315f500bdcd6c34f1c95795965d9ce12c720b72fd8780453d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e99152ae18d0b0223ef14837e97fb39bc1bfd554e42fa413f3f1a1d5cb2860"
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
    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/sqlx --version")
  end
end
