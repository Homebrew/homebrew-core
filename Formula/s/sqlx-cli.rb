class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/transact-rs/sqlx"
  url "https://static.crates.io/crates/sqlx-cli/sqlx-cli-0.9.1.crate"
  sha256 "7e99f14841a9fe8e5650ccda3dd7607f1f22c33af86b17b4872488a2146bcdfe"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cfea7b7a8e929a3443d1494248ef6ea4a5bea113ada91918700f6a3eaf0e65c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5eb5578d51a6ddfd552a2e52262c08eb6bb42b638ee6f946f38508c1dbf776f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec84e292a78702a703276ba0d79c73ad24d5451d817e54c43375583192d452fd"
    sha256 cellar: :any,                 arm64_linux:       "ce250ffeb35d1e2ef4962aa6f7daf525ba590ef8a854346ec477cceeac05e50a"
    sha256 cellar: :any,                 x86_64_linux:      "a0c2dda0c5e4136716e851ef0251c213e50dfd9ab286cd23cc2a6e6b7c85469e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sqlx", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlx --version")

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    output = shell_output("#{bin}/sqlx migrate info 2>&1", 1)
    assert_match "error: while resolving migrations: error canonicalizing path migrations", output
  end
end
