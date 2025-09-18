class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f348a21547cb2bfdc294ecc8a846eacec1708c29458db9afb6f8a1239f68d6cb"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4cfaa10f4b329f49d24d50df97f84fc1457d655f27b74da5849a72190e052473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "44a403226dcc034a328658eef19b96d0abf441c2042d4777fdad22b74dc4cc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b29676af2bbf22ea192ead306a354827084c97c13eec0bac3f51a05117a598d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f233439c22ef1cff6dfda8ee24fb2ddf5e4a95c30ac5381b8d7163f9ed2d0619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7c394f7f2fcbbb5c77df28da0a1e7a19a33e65352ade54c1a7ed2ae962efa63"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dfcd8ebd783f1dd0dc53e59c54e513240d690eee50cecfb9ef7e305871b70cd"
    sha256 cellar: :any_skip_relocation, ventura:        "67a29159ee666c5b6f0df160456cdbe810458da743942096972f7afb14d4a652"
    sha256 cellar: :any_skip_relocation, monterey:       "7dfc950175556a422af65fe3385113aced74343cf5d472d8b07542f59dea1e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f81a7c24e3998e367e975ee46da03f2fe8c368253e93942c3735787d9d8cab16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e9d423508ef37fa5359093653cf9dd6766419b3480159d7b9dd4fdb65a7677"
  end

  depends_on "rust" => :build

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

    assert_match "Error: error connecting to server:",
      shell_output("#{bin}/reshape migrate 2>&1", 1)
  end
end
