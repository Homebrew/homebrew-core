class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "22f35f72478ce920e48705a6ab4ff56e8c3186922c2ff0346d287b8068860aeb"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "499e2a36072d47b85e943d723ea39314055be0ec93a7f801f590b65a35534135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9525f8b5d25c4e1e658264824a833c440e332b1256c31902980eca29f00023f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27658f6011ac5458da2ddfc29e4441ecbed59838b5a7ce2859399b5c8e51ba02"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca885a9ec50318400c63eea768cabbcd8dc6ae0b7d8140797cc9b664b4a0748d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8739ca2b25e1dad9cee5149e176f5f57ff34fc521014699d3d7521041867481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a60602f16f603eafeeb544ef8e24415679ba169c0cbd13245d75e3c65309a0f"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "install", *std_cargo_args(path: "crates/swc_cli_impl")
  end

  test do
    (testpath/"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin/"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath/"test.out.js"

    output = shell_output("#{bin}/swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end
