class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a166ea3f0a5f0bfd490cb36b3360b51e40a278e138f40a4be601faf4d33f456b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  depends_on "rust" => :build

  depends_on "rustup-init"
  depends_on "wasm-pack"

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
    pkgshare.install "fixtures"
  end

  test do
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_predicate testpath/"tinysearch_engine_bg.wasm", :exist?
    assert_match "A tiny search engine for static websites", (testpath/"package.json").read
  end
end
