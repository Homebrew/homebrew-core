class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.6.1.tar.gz"
  sha256 "5d22b7b2f015c79734f35d0fcd43b21bac89d9032dd66307450b3b8c4cc0a33b"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c0ba6cc6e8cb823b6ae4b723e262ac9559dcb32e63830dfb6f6a49c5c5a1617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb86556a181a162f1137ff6725c7f1261080369a8d888aadc82c5fc2ed11ccec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e03b64855b0ead19d73ecc3ef909a848be65cad053ac90064685ecb83321896c"
    sha256 cellar: :any_skip_relocation, ventura:        "e1141f94a3ed771638371da2138abf53debf733ad26ba4c4a464a98d2dc4b1d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2758bb9ece62be0961b0372269349912414abc658a6501eade88a2c055cd92fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1e1609d559dabfcad4979db9a14621aa44c644cb662493d07efe3147ecc1115"
    sha256 cellar: :any_skip_relocation, catalina:       "596f99930552bc9101e29a11b38effb1ac12ac7b571306cc0c3b3820f97800e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56244c04af16653423ae6ed64c2bcc8bd116af638ef48dfeeeaf4ae39de01062"
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
