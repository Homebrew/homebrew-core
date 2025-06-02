class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.11.24.tar.gz"
  sha256 "115386a63aa890df8ecee6dc3daaeced5baabc0b1e7620b591836ed7586b9cf0"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9d865dc01a5e39977ba398eb872ee5d13745f9c1f880cc72bd88840242c493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7e4bd74754cbdee2361cffcd506b320dc7320ee54f8022563816177e28b5df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d19c4c3437a45752f9faa279e8abb533f4455e57da47239b3408ed0e71d0f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d49f0175024e7ce7a6e080a99259e1ec28315bd8887bb276c2dc726dabce56d"
    sha256 cellar: :any_skip_relocation, ventura:       "1a545816ed53c64cf03a0a69d045714db9acf9b275d4be01b4da76b60065e7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed36f1ecc1d548e48229f0fb7bb45f2a35c837fe0d3cb3268ed3c05e6341abf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e300f564a9d808e054c0070abfec5da9ecc2034412bcc201b7b94bd060fb7b2"
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
