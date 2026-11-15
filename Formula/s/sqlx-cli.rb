class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/transact-rs/sqlx"
  url "https://static.crates.io/crates/sqlx-cli/sqlx-cli-0.9.0.crate"
  sha256 "93ef3857a4a0b48fcbf536b77a9122a35c7631686f2ccfbc75e616335771e8d0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17f96346339df8309f2f8d5020a878c3a794da751dc2a040fa71de00f8970e25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1345cd07b26c471448eeaa7845fbe87ec84f94c24441e38179482dd6e554bfb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf39cd229538f7cf6c608a9d22d0a7cde3e8edef84eb1e12478151d8e1dac9d4"
    sha256 cellar: :any,                 arm64_linux:       "ffd6a2e3df2697ab46d243288e9fd1a536a5936b0b0f46a3f721de38816f2b8b"
    sha256 cellar: :any,                 x86_64_linux:      "1961041ef533e6f542d3b94951820947defe630ec25f8a33a67eac1f32eb61dd"
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
