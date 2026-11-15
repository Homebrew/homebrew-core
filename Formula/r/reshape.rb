class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://static.crates.io/crates/reshape/reshape-0.11.2.crate"
  sha256 "17c0680e957ab12c43da0c55741ca7c1dd1003b20216ca7f84ca1d3aff57391c"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "919a72c78fec6d8aeecbd0c2eb836a957dd18ed6b7bcb12db06f420e4b4e59b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "051c88ed0a4bf73cf812a04ea754fc8ea9838c8ecd26e305f57552ef06a93b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7fe005ae39d7393fe28fc3fb9e659f352f96bec9c33af198397ba80aae2b8f1"
    sha256 cellar: :any,                 arm64_linux:       "88ae091a68d41d958d288b4333462514883454241f605ed14f6c95d421194f8d"
    sha256 cellar: :any,                 x86_64_linux:      "4f70aeaf0bf835eb149294d5d8c3d6368526597ced08d273ef9b873d31e81496"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "generate-lockfile" if build.head?
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl) if OS.linux?
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
