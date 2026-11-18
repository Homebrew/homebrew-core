class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "66a57a27d156181f8268a15c53755bf09f6119127de71b4a1f059badf80b9a90"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fc724be49ada8be33c81340f3235122a28dcbbfc8735734899e902327e836c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfc01c6126142cde0156c9a4cb8d81fc60bb9b0afc4b9b8db3c4a9b07d9f8358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f10ee62eee777c1e75a292bf9f710888684c2efe6178f60ae06350412b84c14"
    sha256 cellar: :any,                 arm64_linux:       "3c3655e49e0aa2e1c390efd27bdcbc8f30d67b4e53b13ea8ca8c3c4e67a62150"
    sha256 cellar: :any,                 x86_64_linux:      "e6ef087bccade98c97719cf20f0516c98289cf243a76ac473860f6a4a7d8f260"
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
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix

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
