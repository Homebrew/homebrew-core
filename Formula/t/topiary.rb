class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "d0cc71693a1d889e6031eb9b0ad453f50bfde4a9bbe58a2294b9d2c88449a06c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcfc0bfe103d0d3e81e1696a08833af5923f210c6d2c7fa53b8ee6c1785e3ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3beca3775fe629b69aa19f013feec5fec4ef33b30d18f07860db0aaf0c52df50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "079b20943df3e5b1249e5284b45b68428ff72395588f11752431971096733d4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "456c3f5f7f5d89543b0031c66a03aefea0e92200153e6f35c1707da99d0fbbfc"
    sha256 cellar: :any_skip_relocation, ventura:       "f90b9b49e3bcb191a13a7875d74c162e0d2e9068d8951a8b9482a9201ee8dfdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "464120b0a9d2820bc675d360474be410021f25dce2c9b385c397773f10f738a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b83fc86ee8cd29d1109c005d7eb76e90a0807f404085b2d194e5131ff65880"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    system bin/"topiary", "format", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
