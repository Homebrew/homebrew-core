class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.6.1.tar.gz"
  sha256 "5d22b7b2f015c79734f35d0fcd43b21bac89d9032dd66307450b3b8c4cc0a33b"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27446a0d6f33ec3760ee345043bdd051aeb8f7586686f00da1f6e25410445ae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c06ce4b5de84ffac95c8747a7ac9f70b0cbc03228e88c82a31f79b0784a50ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b34a1114fd84af28efe17a21c1d8e35b2327ca6664431894c667b3f32aeb174b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2f1b5690996bde963e49f27d17d4fd05500f18f7eb3d1f0bd6b456009330d64"
    sha256 cellar: :any_skip_relocation, catalina:       "7b53bf8d702af75f35f9bb6dd987ceea0f56b346416c33299a46b244e094b1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87459ce6f83d8d03b7f40d049579d81a7f70d966226465dafaac37cc013acd2b"
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
