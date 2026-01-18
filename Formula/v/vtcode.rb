class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.65.0.crate"
  sha256 "70370fb58a9d43b88bb89c56dbb27fe3ef744330393b5518a9c404d22e79203a"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8864723d3a2df42261b0f48c9abc32067e3fbe7ec4f538e260c52a03e144ce67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c276e8db37e5ba8fea62734f8e854ef0964065b0d60465a0d62e94c79c83a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb63c238602309c0a9a518da0b2cfbacee7a7155e047136884abd56b7288b6bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "affc17168a8e4216c6f38f03108f0db3ec7232c1adb6c32a157023435abf80d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bd81c2c1afab4ea2850739bf74e49b51b69a70aea5172527ca89732d1fb2f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd5e882e5bbc559c4305fdb8246a1cc81e17c00c025d050580419317c2c496d"
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
