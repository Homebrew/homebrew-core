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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65ca51f4542c194937c7f8554c162afdb4780d2dda49abda20e07a439a447b4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a24241361022483517da9bad68bffb16cdce75a0460b36a2271de28b337893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a68bbdabb86015adf9b81ef5574b153a1b039637e51879156a9fec2f44914ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "8faeb3799bc3357780523aee58e24432de261b0d61b36ab8eccfbf1d64aeca8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8805dbb6e6be7e9d8c3f4cefba0d99846d4ec72d137c4f5168372761fdbfd9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9fa30f81da28f1e82207af272311e2363c36a975776cd65cfbbf36008bab0b"
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
