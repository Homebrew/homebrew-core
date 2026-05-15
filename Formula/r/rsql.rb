class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://github.com/theseus-rs/rsql"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "37ec3b5b364d0444657116babf6969c0cf2d071debea4558f90d3173ab685f73"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a439617bc4d7b2d9ad8cd1e7b4f77bbad1d3d40049b8f0f048b172087f12289f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262c9edff604425b3f151d2a3e5f62e07a0aa51659feb22a735dc363568a4eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6ac41df16e3d7a8e14ca9fdd8b4da2df57a4bc37f61546acc8015e619d9574"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1f0469221de743364b2be13b241dde7b91fb3c795feeec8367e5032b52710b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfdf02e32c0a6fd49011ddcd752ea8a6ebc9ab5b61a6e820981afbec92162ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cac0bccdc5b023c6d1ae310b3fe3190acaf40fa704a84b7660a81aa5aaef995"
  end

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
