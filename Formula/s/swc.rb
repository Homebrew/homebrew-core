class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.18.tar.gz"
  sha256 "fd7ad6c44cccfe7ad1129ac1e88c0a09bab24b704ef418d92e3affa0fe00b3ae"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2849922031c85346b7fb90400e42cd959fa04d639dd6cf492d1f312d7726a15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8a0495924d162336a1f76b9180621821476bd29422d933d5e48c094e9fff6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ae00de6d60a1dabe51934c63682b5fe60b6547745ebce32f0e0c92a92f79d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4a2d46631afdcef21925b755b4dbdc7f3ebc9b62d59a6cb7a2a0edb949e6478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "589760a048b5a6a4c6a62172aa55b0a8092e9ce2b17f8c817bb11cf54c35f6c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2633b1ca374615031a159790957765acbcd50ea4a4b48c504229626efb094c"
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
