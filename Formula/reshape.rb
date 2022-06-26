class Reshape < Formula
  desc "Easy-to-use, zero-downtime schema migration tool for Postgres"
  homepage "https://github.com/fabianlindfors/reshape"
  url "https://github.com/fabianlindfors/reshape/archive/v0.6.0.tar.gz"
  sha256 "4a69ec4476e0983224d446b63ebf78e3f764b57ac4e73aab49ac34b8f506851c"
  license "MIT"
  head "https://github.com/fabianlindfors/reshape.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5c1056855d5b1c4a0ea5cb6e12ebc589903148de91e38f67b2036b59e7efcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "961b890dcaa875d478cbb368de239eca807b236f08ad7067c9f082333d60b521"
    sha256 cellar: :any_skip_relocation, monterey:       "0963250e57b8b8cc51afb6ff4eed611e8fa6b3591d48196194aecfa0069527d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b27d2e05c280a2f613d89a4f687b9378388c3bea4d818e669794d7bfd2217c88"
    sha256 cellar: :any_skip_relocation, catalina:       "ec7f968b52f5821c235394ef1d81299d237167f7ba95ed9420c3606c33658ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d3ed3ac9d59201a69ef95d2fa3c1216bb7a1586143a6dddb23ddd345ee41ee1"
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
