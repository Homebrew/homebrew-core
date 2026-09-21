class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "6272d0f42bda3591be28bf465de4c9dda4ac6967b548a680f48379e5f0bb569b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0f503356f2e04eb0253f8a69d7eea188b143fcd5bfd29c0fa8edff03e693349"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd1bcba140be308db4bcbc7b0209b7a67aaf7beb00061e1f18e2dfaea6117e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a29b95208d6fbcab54ebe8bca57e339909c57843e62797d3aa69aed42e169c52"
    sha256 cellar: :any,                 arm64_linux:       "3359c0a410ba09bad4ced8e48d24532b21c5f10687f597b81e92ccf89377427c"
    sha256 cellar: :any,                 x86_64_linux:      "6a6f6a34a19d3f81dcac917639cb7416b68861d70eb4a378964d862357f8cc2a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "wasm-pack"

  def install
    system "cargo", "install", *std_cargo_args(features: "bin")
    pkgshare.install "fixtures"
  end

  test do
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"
    system "rustup", "target", "add", "wasm32-unknown-unknown"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_path_exists testpath/"wasm_output/tinysearch_engine.wasm"
    assert_match "TinySearch WASM Demo", (testpath/"wasm_output/demo.html").read
  end
end
