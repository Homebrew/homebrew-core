class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.180.5.crate"
  sha256 "a070b153659dda298fc9fab9fa1a9cea1037c0c13a88bdacfc617db9ce42721b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a35181d13bf1375c3f2ec4bf751c0dbdf49d36fd401af825f030928345f07cd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2c68056e7cf37e5205533eb58759ae4941cd3eb1b1b5df7243534970b325647"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b8c18ec7473f613cbcd6cb25d69479c9cb71625aceba093fda751f735e6f13c"
    sha256 cellar: :any,                 arm64_linux:       "79ee1f7add8c14e0e32fc451af6ab1df865149b0805536c65aed79414a1b1de2"
    sha256 cellar: :any,                 x86_64_linux:      "95eca4626663741090b5d60a4b0a908cf2d8065159c6d0c523c1581cd5e3c62b"
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
