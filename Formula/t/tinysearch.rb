class Tinysearch < Formula
  desc "Tiny, full-text search engine for static websites built with Rust and Wasm"
  homepage "https://github.com/tinysearch/tinysearch"
  url "https://github.com/tinysearch/tinysearch/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "103214d77f0624bbb7e396667136156fdb8c8c7abeb6860adb231bf2a00b256d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tinysearch/tinysearch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "604da29b5763cbd83ee3851adf412ebc0683a39f82c4f6fb5db430c21e5804b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22ba810fa21cf5ed9b4b3da171f5c528812ee9a7347ed87f658dd9c6cb930b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3112dab46ff4f6ebfcd130e186cca018d7e72cf503a6a74b8e632dfe30ff147"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6419da17e1e7c0f7bc74eeefd60d9fec429f9a351bfa6732336207da27ba62e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3f5895d2f977f0c32c7a80798922f56ea1f628bb6522de0243a74ef9ee6635"
    sha256 cellar: :any_skip_relocation, sonoma:         "0150d38ad3672b677894cb99071ad87464ee130a5aca00360197fb3cc488afab"
    sha256 cellar: :any_skip_relocation, ventura:        "149fcc1be09119c692b20381ed2646170c004909a1998ddab8b5e451d19e6c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5e206aff6a7ffbf2bf1da5dbb9907e6e72873ad507059f53699984080e6fe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a256b304d49a871b20915721fde4aea47ef132afa5cd537c6bfba36b8ff24d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741bdce133c7ac5a2fecddb639fa17b3d7b11c3a2adda9f7998bf69e5b2376ce"
  end

  depends_on "rust" => :build

  depends_on "rustup"
  depends_on "wasm-pack"

  def install
    system "cargo", "install", "--features", "bin", *std_cargo_args
    pkgshare.install "fixtures"
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system bin/"tinysearch", pkgshare/"fixtures/index.json"
    assert_predicate testpath/"wasm_output/tinysearch_engine_bg.wasm", :exist?
    assert_match "A tiny search engine for static websites", (testpath/"wasm_output/package.json").read
  end
end
