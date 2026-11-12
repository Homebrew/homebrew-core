class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.182.0.crate"
  sha256 "f78e6f3508917498cc5e98ddda2ac6f42a2094cc41c4653daa062f66049fb7ec"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ef907362cf14750c3d142f3d4d72244df88228bd9bbf8bfc47473878d6edd1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c292dcd203e6925ff42f5c30c9d96c5f847cdcc0b467a0405f2cf74555a1f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ae5bd101d096169a5edb428a4bdc9562d42cef9778261c133092e6320d9c4f7"
    sha256 cellar: :any,                 arm64_linux:       "bde2d9fb54b4d16614383b79c7bafec6b11d9d68561fc1584ed9c236e68c8f72"
    sha256 cellar: :any,                 x86_64_linux:      "8bafd2a3ad9fa999555de7e6117a5c48f938632059999d8cba5513bae74f6568"
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
