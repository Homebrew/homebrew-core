class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://github.com/theseus-rs/rsql"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "4dc7f6bdbf1fe9646ca64e307db4249f1f28adaa0858a9fb0ae1a04ebf199e82"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "650a113cd30642141965df714e358d4e3514fafaafafab32fdd37536fcb07f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d3d70afcbc6cf516739e54c062dc57a1f7f86ce0d076c29d7c97ffcff3c9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d7cceec29196c5cde0b164aa6fadb57b6b3d3d00caf4d74e55afc8fcf1eea20"
    sha256 cellar: :any_skip_relocation, sonoma:        "3344174d3044d782629662e1d01ff66b38bc640d8accb367c1ea5ffafdc16b04"
    sha256 cellar: :any_skip_relocation, ventura:       "9c283478412fbdd4e2af1d3b2de915da9fdc486ecfb504a3ccadc99f0c18a9ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cd0f1bca34f7f7be730252ee3815f7f255c2a53b1b1bc8b993368c31c73a02"
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
