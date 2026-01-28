class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.73.0.crate"
  sha256 "ac170747abbf227a8bfbcdec73893ae7fbe33a7f96b77cfb55108350a1801a27"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae1ccaf1ee00de8c9e1c0a83423cd5cb1e5bf2421aca2670f0e3935254e0f27c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babf573e4e4162b00aaccdfe384e68ebb367bfa54917a3e6d4a8528f59b3c92d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d80c3e5337c06b5bd3a6e221980c0789fa16febc6fbbf82da6cd78c289e504"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fef31a44d5af5b7137347b8fd8ae488b27593271f20f20ae3a5931eb6c405ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ce2a9940198bfd627947af77e0bd2fd70a42dc1f4bbbd12196771aa66ade049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa4806be12601d37fa0bcbceb6681359be7319950311c995bd951835b2e8b738"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
