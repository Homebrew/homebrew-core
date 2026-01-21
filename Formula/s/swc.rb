class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.10.tar.gz"
  sha256 "446dcdf1575f9167dcf92daa9f4bbc36bf19c208ff05b0770fb7c0b0edc3b3e2"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c997d9f6e046b8af4662831b518b0e52b18813be3aca1977a39f51d0b842a5e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7a7400696b090925ca17ffcafc342e89e4e96afb9794c6e27747d8ca7d5e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7d999b8cb2e16881d034123fb2e593b9a7c11cac3a5d05ace34187d33589148"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0bb712518a2d738e25b08fb09160ccc0b250b5d85d13d749f68ebe3fcb71be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330610a2783d13fbd4e67cb9046a854c9eb35bc3446f76275e56910aa062b16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807c0db854065e5ab4b63a55f25a12c800b11c5206105392c33202753157a26d"
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
