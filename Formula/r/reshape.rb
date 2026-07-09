class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "a613d1534c7a73fcf27e565453457291ca282bcd185cb91ae10cd6347baf9c1d"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4db3b20dbf4a9dca55f27858e71c701666980a9adb1bfbe8aed8a13d43da7cb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c20de9037dc5dd2f6c35c3fae7fc19a7af985e65b9c01825d56d7848de1d57b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c048ad94f9298a4be48a648c6869c8e2c5571351b8a77cc73f7709936799340"
    sha256 cellar: :any_skip_relocation, sonoma:        "1442f6c2a3fbd98287f1252e5529a416c85b32ec2f35d060bb976cf3d07c6190"
    sha256 cellar: :any,                 arm64_linux:   "fe752faf0908c7851d802b148bd9e4720b65d83648b1e506c0347b8024fd2260"
    sha256 cellar: :any,                 x86_64_linux:  "fae109baa04eda4d730ef4b3700691a082c1eb8ab9e653e7320a3da4d5fe8f67"
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
