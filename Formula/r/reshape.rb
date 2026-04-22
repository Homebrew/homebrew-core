class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "516c68a38c22be1262f3e3da45a9b382457299a3c7503bd018f358088d6970b1"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcb33e42f5519c7e852b82439f0009fe2519d222dd1d555c8c52b5916b99213f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0deb2c203b0fa63a69c68c5b8605e32aedea06293112536988b66827e741784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d2e4941c2e24cc9e352b8f38a8ad9858f43d0b7fdb5d27b137fdac16453c640"
    sha256 cellar: :any_skip_relocation, sonoma:        "9096aaa64c7c4670901e34e9b863b5c6bf0689712ff5e2686b73e9ecd73412b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17fca3f129fa2a54f00958d997824938d743231e88ef40242b40cbead2b0e55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4584424c5d8504185de183e7f64bb6996fe7b7b0fe02a6e49186677137642a77"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@3"
  end

  def install
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
