class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "68bb132c7f827ed40d31948432dd4175f7d16aa745f175b9321987123d9d236b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71d877e534ec6ea26cac2b6d03595c04791c7faa3c1fb0ab75ec7811d3c41f96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5ee348f895a70f357ac906c4a318bcae339e39bef2a106bc8b8494d8273d196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d71fd5efddc83750ba48be983ea9358745dcb0bb095ff1b43f3b498e9667895f"
    sha256 cellar: :any,                 arm64_linux:       "6cd1e04a22dc538a4b6a9a65d26e744c1da88759c6687cfb3bb97ad2d90799b5"
    sha256 cellar: :any,                 x86_64_linux:      "6e165d32559461e7c222c43948a6f0a39ab79ee5eefaad5000e2c2328d3258e9"
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
