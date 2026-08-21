class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "3b74a362a643e3873f3e5e2833dcedd9dd9b953c7896c85aa2e40682dc837a62"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "442def6439e3806dace82c85b73c25032effa153ae57e04708d16a5114f2c9a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8c766112d1c9b80643c71fdff7fc166d583af53e990cc12b9f7c803b604b18e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde1dd40510e649c50ec493743c04a23871c3dafaee9e5c6b59417069a45c0cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a1bfdbd33753a6140bfc864a25d9559d5e6c296e53f8a51904cf73d2729894a"
    sha256 cellar: :any,                 arm64_linux:   "b737ee9b1a6deda3120d0fa7a5c1c47ea4750d11288e1dc9f4da503e20207298"
    sha256 cellar: :any,                 x86_64_linux:  "6df69069f61b6457bacb6be69b31cb3fbdafb8f2f47bd9d5401437e918d4b2b3"
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
