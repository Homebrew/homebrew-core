class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.13.20.tar.gz"
  sha256 "cff73f4ba5f229630079e6c74159d1cc4f5b060d71d87e4f809017a64aba76d2"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f42db71682fa3e9b9676fce5c691332f938255a80a5aacb1a4ae03f3f57689c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f9302bc5db17308ac6ba252d2fb9ab2c22b75e355307b4cb9d664aa0538712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72ffd80d4cdf03bf1bd706f7154329527e850137e416e1a5ab74a26fd8ecbd55"
    sha256 cellar: :any_skip_relocation, sonoma:        "31b1a1b33dca6b7843a3b411c72362b699e6ca4a8c923106461ccffb122a4a98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ef9c045528bcfb20fba1504fa643773d25c83b229cf31969d9291608b01aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38f03a89e3f16bc9a250c70e08dced72cff66430fdb0d970bc60493ae06e44f"
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
