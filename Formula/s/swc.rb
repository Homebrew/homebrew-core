class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "522e747d00cc0e3c288b70a8eed2e01b4017c880f980ff077c22522d6a5e24e1"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0eeb3bdf5bdaeb35c9d1ab1e94d0439bf8535e6aa5d605faa6d6c23b04d96c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca0317ca307c2aa744873f322d6ad6f6d0adf1471df57e47ec4a2437ed143f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3841286856a7db16c4925498186f180471da0da2669e05fe0ba509a227a3380"
    sha256 cellar: :any_skip_relocation, sonoma:        "72cd2baa2d1de6174ff98e358d9101d9efd5e25e139e6d3556ec4d0657ba9f3b"
    sha256 cellar: :any_skip_relocation, ventura:       "7274afd2ae011e50407eda1324652cd7a1dfb6fcc37291aaf93ff880403a5d28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d790586312316ec97f4adfdcae5a096bf9a5758d2986b0c3666f946eab5860a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da8341ad11504fd9a865669d7c50d97b8c37d21e2c14bff10f5a426058cb0ae3"
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
