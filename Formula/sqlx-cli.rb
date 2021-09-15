class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.7.tar.gz"
  sha256 "ee19c1a987a50ce71bc3847934b5d1453d750e23dd5568ade57b084017d8a56e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9a275d490793039b3f19d6dc200f38b998bceb5530a38712c1441159916a30d"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ffa99ad7479092c65979c6e689eb4b41441b69f857507d644c9a5ef40b72762"
    sha256 cellar: :any_skip_relocation, catalina:      "1aa21a5afddcf70e1cabe415c8767070a50ae0f82c81a5ef37dffdb47ec6a49a"
    sha256 cellar: :any_skip_relocation, mojave:        "a1eef88be554e536bcebaf6a637fef296dc87cf4131a5cee4f98b114815913fd"
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
