class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "9d8e73a54ac8fe5b23f938da0a1522e8e057cfdb11f8bc4af7ef0a76558984d5"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d6e990d4bbdcd0188ced49903ae60a49e18811673c48f2bf398426c4f1d50ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afdc2c1eb053b84222f0ed8ccb0daa5e7d83f2a1ced840f455dfba9f01f1f2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "410283dc09dd4c3f4b0056121b65e48b6ce3714f0148d9c3def16acfe0dac061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f43be9e08b3eb949f4c0dc466d2f440d886e0a3990aa38dda01f9b5b863fefd6"
    sha256 cellar: :any,                 arm64_linux:       "e6e5782510700bf7245b67891fed8f5d85cae5639508ce74ece11ebfbf026701"
    sha256 cellar: :any,                 x86_64_linux:      "cc31c5c4eb41fcfc9eebc2dcf832ad2696152c0ab8caef3ed86db9a2d41f36f8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~TOML
      [[actions]]
      type = "create_table"
      name = "users"
      primary_key = ["id"]

        [[actions.columns]]
        name = "id"
        type = "INTEGER"
        generated = "ALWAYS AS IDENTITY"

        [[actions.columns]]
        name = "name"
        type = "TEXT"
    TOML

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
