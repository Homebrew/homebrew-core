class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.10.9.tar.gz"
  sha256 "7e6505bd5fc2b8fa46396c79d98c6bd68fe5214e70e344251e37669dff158dd8"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8de6ed2c71a8cab8bb6d705a1de0a8e6215c466cd767bec3de8eaa6d4eda453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3020bade03052980f330863ad1183c7c107f8a7e7ad2da50f7e9f1c0f2ee382"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c6a1ce06aa11455bbc788b16b3ea81f7bd23337bd3eface46b8825ede157d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c019323c17e64af202d8b8cb0a902fef4e28e36b003b26c41a97d653f98a74"
    sha256 cellar: :any_skip_relocation, ventura:       "176eed5aa8f5e6cd0358ff77216354b7b9e832c1939c083f7b59eaed4a087718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ea09ddc9df9e0f9a6766d8ba7b020b3c17180dd526f4b86740ecc51866dfea"
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
