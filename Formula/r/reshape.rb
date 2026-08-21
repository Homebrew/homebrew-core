class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "8aed2b35a3581d2249c4742139817bd8ef2a5a9da14603809f8c2c295ee8955c"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c203009b980f8c06426f6978fe9751021cbd089d8d967eef234c9336a3500272"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "030c28b5464966e01e356aeba771aa2b1ac7b9e38dbb86df09b360c7b1e86c1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247d4e47c6d3a015a610c5a5c5dc5d58b8de9ffb2cf993a9772e877358edb248"
    sha256 cellar: :any_skip_relocation, sonoma:        "2633615accb3a463e71e6c2ecd57c0d595648b2874b93b372200a16108844d84"
    sha256 cellar: :any,                 arm64_linux:   "8b824b84cb3db4ff4c70202becc99c3fddbca92cabf2e51efe94af48b8db91eb"
    sha256 cellar: :any,                 x86_64_linux:  "9842a8eada35cd96f084b5c3e46ff84e6085034d3b6eb77e6d0847d2d4aa9600"
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
