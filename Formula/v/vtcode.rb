class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.181.5.crate"
  sha256 "2459927de6436b96b6bccda633f2316ec3e66b5535e9c1204c641c7a00f89127"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "315680bc16edb1576a5efd6df57807f1cfb950ec04dcd4126e26261337805787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee779fb7c46ae9c425b70f0c06e9b4c8ed16cf9e032b1b39fb3a035ad33252dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "357ec01699cd5c0da98fc9b68d2f2015a65734692a050c48c7fdddaba6923dd7"
    sha256 cellar: :any,                 arm64_linux:       "a0e9f4811c7de1048532edda9dc3d2b3b9d83ad2922fae3f2e533891b1af41bd"
    sha256 cellar: :any,                 x86_64_linux:      "1bea94528a19d9cfe6a3769549cc49b3ce5c576f890b91606c05a4e8f0c64045"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
