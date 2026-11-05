class Swc < Formula
  desc "Super-fast Rust-based JavaScript/TypeScript compiler"
  homepage "https://swc.rs"
  url "https://github.com/swc-project/swc/archive/refs/tags/v1.16.22.tar.gz"
  sha256 "11e82b947cd2e819dd988c740c5c3f3409cfcaaaec3ab686374774355b912aa6"
  license "Apache-2.0"
  head "https://github.com/swc-project/swc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d63f14d63ae9718163853577a9ea2e1c53f9d81348efb2361327d33db4ed9b1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "378254a1fd26f11a0b8cdd5e11d099d0206afe95bd29636273c2b74425cb1e72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfd2dacecf82dac9c0a16dab604484ada80ca428ee132d48bbb2a6462d1b63a6"
    sha256 cellar: :any,                 arm64_linux:       "7687c0df4c14a6f431db4fdfa743eda2e7f900d9580fcb508f32441b429a3715"
    sha256 cellar: :any,                 x86_64_linux:      "96c4dd4b6aa8226ef9f43f5189a991a0dd5f29bb2a039af4efce0527a6fc942b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargo/config.toml"

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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
