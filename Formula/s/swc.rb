class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.21.tar.gz"
  sha256 "48d6adc070b3b6d1ba12de954ebc3479193ac65804b5215edcf870d1fdc0df7b"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d103aca8834a85782e273ec1ac779db57a7a929af02693fb1356ae87f7295c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "296c2cad6617264740a95e73c3e6a1d3b4703d8b7e9062fa689c3164b18b5278"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362ba0ac420112efc6b3c59cdc7dbd5a9b2663c88c2e489a71e4ad98817acbbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1efa0f9a2ce82a5fb2767b53c492ef19411d14e8dd8fdc775cb18e77bbd58e80"
    sha256 cellar: :any_skip_relocation, ventura:       "eadf794c7b066aeb73623c5a311729d58ad0a1bd59aa697004276c982bd5dfb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b935fc82217aef87567a31e223369520c7a0c0b5f5db3329222073f6d7cb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c15771207e35825805f38f3971b2cb2442a4066dfcf6714031f4dbba5ae97012"
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
