class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3330a8b91a83d9e452f71ba065778bc0eb2be0504f7707bd11b729bf501395e5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27b1c4d80f00537eac5cf8e0c06ee7c5ec3694b9f0c64bde1cf83fd7b9d02a15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bcb1e61a1b15295ef1825801509801a4c11357da93f8b81e23bfcc59757e159"
    sha256 cellar: :any_skip_relocation, ventura:        "280dc34a0daf7c49230a27168d9c54adc9c1160023e52819fe4fc4ec8ce05512"
    sha256 cellar: :any_skip_relocation, monterey:       "c26c581707c1a5d317194a05c694715a6b6773df1ff2ce90d597a439990b5166"
    sha256 cellar: :any_skip_relocation, big_sur:        "e590809eeb3920451cad5946a72ed29c8307e4eb99d5f01ca6d442f50e620406"
    sha256 cellar: :any_skip_relocation, catalina:       "df5917867187c13145ea83ad38f9f285b2597073dbdb434d30c692b15b8d145e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1db2583422d8eddef366f8f587ef875add2657552bfec8e467fc3798f3c32e"
  end

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
    assert_predicate testpath/"wasm_output/tinysearch_engine_bg.wasm", :exist?
    assert_match "A tiny search engine for static websites", (testpath/"wasm_output/package.json").read
  end
end
