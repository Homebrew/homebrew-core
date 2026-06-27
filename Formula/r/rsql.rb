class Rsql < Formula
  desc "CLI for relational databases and common data file formats"
  homepage "https://theseus-rs.github.io/rsql/rsql_cli/"
  url "https://github.com/theseus-rs/rsql/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "e8425f9ebfbcd595be079640ee00848e99ca67b480a03e13540b0260b7939515"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/theseus-rs/rsql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f615a361f7155424be9f7e6fb86b71a8ae66c95b47be742619194f1e9b89485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb7bcb3cba342667e53dfd0c894dd5c847b9f15d43035cf97be7c3ecf38bc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae90f18e3d5e0fbcc52ac6f5894bb2aefc6cbe57be97bc60641283e9dfe084f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa41b12a3a4505309a3272070110926d443c499c3e8bd4036bf7e624323cb124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455b56c20ae0f0aa500259e4d23534eedab48fd469d1250400caf8f402586532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b45dfb3c0b5df95a28663c06b435f4a184cf727710a92aae9d5ceea7d261fb68"
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
