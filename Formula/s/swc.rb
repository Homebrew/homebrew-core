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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "880b642a2d5551ce8fe04b9fe5e0c68a12d57837da3ac3573ac208802d6b64d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d14da8ab8c45c3b44f3bd85b12725abc600ebae80a79f81e510555a45576b6b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "949e55c79a6b8daabe6d232343b7be6223a89dacb458559b298d56b8321731c7"
    sha256 cellar: :any,                 arm64_linux:       "6e66825c99b954f75a2fb75158a1ae27ee49e39f5c949640d0364de7dbea191f"
    sha256 cellar: :any,                 x86_64_linux:      "33b62aa9e9041575562f6f7a840efd86fd200d14453e04add717a03410567085"
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
