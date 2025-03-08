class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "e8ae4d133728f46ef20e4805cf13889ba40ce28f2a979f424a832bca54d9a61e"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb4d4fd35ea467a758f649ad42cbf85851016490cf4593a5d3c2788c718841b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b839c0caa22bab7a2d0b19c056df75e65df7fddc2010871726b5fea5a8a49be5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d7089db631429e0b397da4b04137908bec107469dbc481c9470dcade99a423d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0763f32d77eb6bdb8d5c41c8e02bb634587532dcb792d62df95f81df6478e668"
    sha256 cellar: :any_skip_relocation, ventura:       "7af5039664ded793a7a724f23301578a6f5012fb7e6459a97272ba3099b8e55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d0c0e25719ebcd61747557f3929193a6e293392917b6a6691532c56720ccfd5"
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
