class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "248bd0a098830e363c72257a63d88011a6509d21b1303ba7042bfcbc90d016ad"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89e273c4320299330a4a32e5f66bebf2aeaa3e53354ceb2d23f34b945d579372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9bb99e9e164e5b7ad4a80713a153fd56f7f8c2f5212b693f36cf2a7f8af5651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a44f194da588bf3f7093cef3b0f4f3735ea78675341f2858b2a4079f509782e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff23357d695a21725b60d99200fce10a7df72a28840a2e63e60b017ebe34c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2570cf173423a50acd120d006c563b0625eaf91e4ccb7fa3af513227ab438c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b7c7c6fe233d72b455ebd9c6e615095935028a07806f987ae9989f1c2751a17"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
