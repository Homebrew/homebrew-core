class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "d60ae0f301246f2f73e317743233e2a78c135aeb1b1e68c03effa0ec8b5fd044"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a104d93248c65a6bfd6527898d2b45bc2902e532809913a19724df543ea0204d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d382a55cb3e57401e833e16ace095f5df44f2b9a3ce406984982832cd9783aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c7e9271c76f050b2e79d9d58399b473b90bc0721b97d6d6b074afabd4171a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a77e0e3cf5443da4d63d852f6ad645634fef89efd8c57e0bbbf76946456ea69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe430230606014224be9548a259efdd96add941c736f1579708f7613c132d45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b04390e671a4cb878fe6289d4b95448c0f13cb901b81cd53d69263516e0cc53"
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
