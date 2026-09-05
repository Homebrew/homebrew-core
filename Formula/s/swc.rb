class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "3d1709d2cfd980bfcff11275d49f8e32e2dc3c5c0a2e9999eb1ad1eab64fb94e"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "839efb09bf7d289f7d3efd8ad19be4d7c142d79cbbcef64afe5810e521df20b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "737997e6277be3ef370b929cfd3eb43a0da6ae174735d265d3371ac3006de79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efc08514824d2178406f66f889e2f31898de6e9b2eba38eb8ffe7d762e9897f9"
    sha256 cellar: :any,                 arm64_linux:   "71b595b0e5956eb30b880089b9c426e87ec8588217dde8047d57786b4dc51fa8"
    sha256 cellar: :any,                 x86_64_linux:  "4f6bbfa4a652a05e267f272c0b585327ee88c4d555d43250d1664d72eceaaf4e"
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
