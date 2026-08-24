class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://theseus-rs.github.io/rsql/rsql_cli/"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "6b68d37931b47595aabb4d920be64dbd2042afa98b77d071f5db3930087da645"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3953d453c4a0d3b0c4741d0cb13df9fb9933d0602355b04bfc807e70533a769e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e330767631aa248b8e34b011380d1c200acb91ec4a72fdedb5d301d24c9931d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afd4ccf0bddf366efddc46b136675d87dbd95ff6fb0fabdb02c1a49c57e8e87"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73e8518707ae20152d1f347aa842b8256e4631ba1ea7cdc2d7b70e59235099b"
    sha256 cellar: :any,                 arm64_linux:   "78dc8e6db9fe9d62e1c22c24329299acf9ebedd88cc56ef09c1436768db54032"
    sha256 cellar: :any,                 x86_64_linux:  "25e113a3b1587015aeb2b7290c43c43c19d888b9a63b527265f37487e589a0e8"
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
