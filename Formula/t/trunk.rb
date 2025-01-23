class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunkrs.dev/"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.7.tar.gz"
  sha256 "28775d7082f37db33b6ce9ccf2a6e1000677df1ee6c4851f639da196f655341e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29b49f0b96cd5e70d79b88d971e4f72f82d1361f80d1603f871002dd2c1dad1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b5242bed2a8b31cb56e008d46e80d9e9e2ce86f5721a74125d2d4bb4524545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e91aea7c89e45e2bd3d1170daedfc45baeacef07191831425ccfd7559c518f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c576cdb2209e5c593e5f7926b7d053cd451e6ef880288a082b981ba5ad61967"
    sha256 cellar: :any_skip_relocation, ventura:       "c7a07b0f6bf48c881de187d2b0f77c1446033946eaff1f5768346b663cc87173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43cd6392077b4de3c4a76e7152e2f8b127ca84bb009e1b3cde5d9efe70069dcd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
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
