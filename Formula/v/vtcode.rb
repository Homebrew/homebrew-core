class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.164.0.crate"
  sha256 "07a909f10b31771a3cbd79ca4f64883953e8d78f0f0cc3537ba051f514ccb049"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f74764716be9b5af6389be280a9c1f5377e7572deec2eb8ca91b0b88f47f1f54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1920d69dfeb3a5e488d3a8efd4b2e88ec2bc19af93da89b8a7422d083c604c84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5947ccad09fd2af09c77c0f559e4eea70017519af7afc76ae4dd4297d04838df"
    sha256 cellar: :any,                 arm64_linux:       "4e4053a60d60ad0d72f43f7864f0694003f8ed672f2130d9524802b0967321cb"
    sha256 cellar: :any,                 x86_64_linux:      "18c49f124ccebb1a6c20035a47472e2775f3e310035e096afa5541c6178bb169"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
