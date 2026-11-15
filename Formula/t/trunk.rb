class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "b93e82dcb8cb3de8a6762d9d2df60a22b8e0db73c504edfcfabeb8017997bf1d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "392a5793b6e48849767c8bd9bb2ea2f33482d8f874187ca978832db8ecc4f7d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c7eb06b05110ee80ff3a85fe6a690a166f75c756cee0d99a7b924e463fedce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e03bede5e4e512290fa0ae5044476ca013c592230a1e203a2385cd3fa5f85a49"
    sha256 cellar: :any,                 arm64_linux:       "55201681cf31c74d1f1b8d98c6e401fe1e0773e2e5f960696d92341485ebf6ce"
    sha256 cellar: :any,                 x86_64_linux:      "5405f9cc1bfc2c65bc1a59105ef89d63e6cf79eb52522c9964766dd301a1f22c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    # For features, we disable update_check and replace rustls with native-tls
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "native-tls")
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
