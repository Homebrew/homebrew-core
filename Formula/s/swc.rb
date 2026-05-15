class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.33.tar.gz"
  sha256 "f504295fe9c3b5972f3c93a8a31bf2594c0e7efd7ab4c04bd9669236598d1554"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c318b10a991189a8d6dcc9d7d0b4a0a52090f57492cb8943601d8e152fd0cb77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede51057978ec58dbec181ab038e6d4996cb5c72fe1f2d65158507e8c0aeaaaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebf63f9b9488dce711bbaac0daaee9e657eac830158f5fe21d677d193a84bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c130dda657c6f0f3aaa7543ee58ed403fbc0120a93262560b9938ee3fbe73fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391d75a22038a7c2ea3ce132e153306f30f48530faa307aae308f26f0223037c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e961c9aeedba5e47630ab50ae1b36d538489dfc600e2df1d644fc406939fe9"
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

    output = shell_output("#{bin}/swc lint 2>&1", 134)
    assert_match "Lint command is not yet implemented", output
  end
end
