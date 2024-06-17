class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "ec388590cc15232eca9d02356428c0527a6cc599d09136fac46f62116050fe77"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0118f39aa62482fecd023fcab0fbb1158b0c27ed8eb1d07042562724d77547d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9b62fd481d254b3d6b049f774873d2c4acbf8d26ecdc821b3b6d4d0424c715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f341f62224df437146e81495257c53bc324d55813449b04fb84eba273ce40b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0316ec1f0e2203fe90e2349c3a1edc5cb6c1455e148a8e0951f82c3156216cf6"
    sha256 cellar: :any_skip_relocation, ventura:        "95539c81fd95934ee4729780c48e4d18fdb6c0cb369f4c58bd33950708b7ed9a"
    sha256 cellar: :any_skip_relocation, monterey:       "b54a2497f5b34fe7b94b2268e83fc6422a6d5846d380fa4efb8cd728f9753ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75761f1ed65b9854bcd12c10bba3a1902e6b14b9c39e144b73942b766b4ca47e"
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
