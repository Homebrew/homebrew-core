class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/topiary/topiary/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "203bdc6007989f51ef728424c7e051da2c131c0415fc76fb359da8fc49b8006e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20ad8cd8c160af31d9bc68511cacf4987d942cfebc36aa16e5e7d9aba13bbe03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13ed87a3bb1782a6bf2d88efcc3a7f033dd4cb544a43798338fd64894d998b03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92956d7622b98e73ce45f8a2beaddf7c13c0b68d63746849adc5977b2b434fc0"
    sha256 cellar: :any,                 arm64_linux:       "995f80b0e710d71d454de9685a2543c33b8c67fc6d463dabc23bd1f69b4ff00e"
    sha256 cellar: :any,                 x86_64_linux:      "53152a488d481095a1beb53738a2e0e36cef0c16c4e67d5776dbc589f9892168"
  end

  depends_on "rust" => :build

  # `test do` block downloads a tree-sitter grammar.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
