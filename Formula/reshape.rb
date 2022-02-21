class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.5.1.tar.gz"
  sha256 "7643ceed45e79202edadba70ed8f06f24fd25b3b21898ae0d6bca82f3753df98"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a210b909222bd8944a6b0c72f99a8c4a9d953db5191df1937bc953aba91f3cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70fd7ff6e70322f04ce9e678bc692e5ac16929ac4c45b61e060fd3f5d5ef8e64"
    sha256 cellar: :any_skip_relocation, monterey:       "15b90da4bf240cf35d8671d2a0f1bf33a6371193749b7063514eca28ef94cac4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf22431372514ee64b8269ea2e2025d82714ed59a6ab61038a47c583f7465970"
    sha256 cellar: :any_skip_relocation, catalina:       "b4b55cc7e25e542f1e5e937f9eb21f75ffc4cb7e86801d53d9977262733ed798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc062c96a3d2d577db7344ff08a551ac8f38565879a0bee73fab0b0861b78714"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"migrations/test.toml").write <<~EOS
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
    EOS

    assert_match "SET search_path TO migration_test",
      shell_output("#{bin}/reshape generate-schema-query")

    assert_match "Error: error connecting to server:",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
