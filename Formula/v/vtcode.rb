class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.116.0.crate"
  sha256 "60d620fe64d995a4d02e73c61576e62fb5c28fdbaaebccb0d9bca0c42a87c56f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c77eadb8a6f5ce8b9f602d5debf5c0a2cc513078e992cf4e0a108dd3db2a7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae607215f26e3fb6e342cbb49826daf5d42808942367b1f1fcd0bd144a5af4c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "166ea320609132cdf4d66c66a8e9e6c23bc22714b64e346ad6a3a3e3b7951e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e8eaa0dcd3d9295563b46bce13fd416b93358152ab8bfe073a70624147d4cba"
    sha256 cellar: :any,                 arm64_linux:   "a077abc554550b24c761837c3cc582bd967c0fcb76ef08a34a5867fac69a110b"
    sha256 cellar: :any,                 x86_64_linux:  "549c17b322c499f014d9c74029ae70ce47e22e3cc51d59efed1ee82816ccdb4f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end
