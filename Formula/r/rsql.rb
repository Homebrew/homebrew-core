class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://github.com/theseus-rs/rsql"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "9d7a3450f0e883c1ca14719c3ed69e63c7dc1066cf3fc98ac025ae2d9b76e68a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rsql_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsql --version")

    # Create a sample CSV file
    (testpath/"data.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
      Charlie,35
    CSV

    query = "SELECT * FROM data WHERE age > 30"
    assert_match "Charlie", shell_output("#{bin}/rsql --url 'csv://#{testpath}/data.csv' -- '#{query}'")
  end
end
