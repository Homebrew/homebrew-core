class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.5.1.tar.gz"
  sha256 "7643ceed45e79202edadba70ed8f06f24fd25b3b21898ae0d6bca82f3753df98"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd9972c5d4827af99697a63fc17da06f4e0d5ad31867fde1ea644e117b01e20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd78047e9268d619535734fd6ca7dc3770e5adeb3cb581d10df977a87c9c76e0"
    sha256 cellar: :any_skip_relocation, monterey:       "e5b9319b0a959d5a6b8f248bdfb255165f52a7cbaa8e4a64dfc7660d75adbf88"
    sha256 cellar: :any_skip_relocation, big_sur:        "7217f769a48c2ca504e3215076c01b638d7fa55ce02556c47fb494667a3554cf"
    sha256 cellar: :any_skip_relocation, catalina:       "308282ce640c2dccf57eb5383ab5e05fd3642689663129d5a843f9fad124f2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e76e39f127b72a2b21503484753fcd07fd09cea36a81ae85772bd52f8850349f"
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
