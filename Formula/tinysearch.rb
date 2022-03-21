class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a166ea3f0a5f0bfd490cb36b3360b51e40a278e138f40a4be601faf4d33f456b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  depends_on "rust" => :build
  depends_on "wasm-pack"

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "fixtures"
  end

  test do
    output = shell_output("tinysearch #{pkgshare}/fixtures/index.json 2>&1", 1)
    assert_match "Compiling WASM module using wasm-pack", output
    assert_match "failed to execute \"wasm-pack\" \"build\"", output
  end
end
