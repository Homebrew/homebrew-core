class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "516c68a38c22be1262f3e3da45a9b382457299a3c7503bd018f358088d6970b1"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156d49068d0e0fac6b609c466875cedb2fedd39f1b5643c12ff37fbed78430ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ea97bab6357c273ac184e0e08ef31d9eec02634db82c4281ffe5f7be4dcf31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dd82e64b1a93122a81a23e198f3ca8a2b85d0e31bd4dad5e0197614e68fc62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c136b7487d666d02b31c7778fe18a03bb35b2735037a21e74e98395b98a7bf3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8073e96cf71f2e46e1d2e9ad085fa3253c1f7fd760b4525ff49a251f7045d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a848ec4c95b05cbc61023736b2d650d1048e708a4e015394600f3842412133"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build pg_query

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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
