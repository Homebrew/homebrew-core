class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.47.6.crate"
  sha256 "a35a15b8975de2e62f1d1c931f8f856cc82aac0abe2bded1ebd17a36985a73fd"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43c0629a61bc4080f7a769ed593d46daaa38d2ee515ac2e2861d57294c6cd4bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118735d315d4ea30836c36aad5f759b4bbc7a6295a01998696766ad512be1290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a46555f99f5cfe0ea4f7d8ac953a084ad2a0b1cf8976a372a801556410e937"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ffe169a204d6e90953114d907ecee21bb42a0c91ce66f847398e436f030de0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad98279f50782fb0e15516821b331e220f040c30601f86b15f01548ad0e9d07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5023ee7af9ed92e4865c6d05143f49be95b2d06b30814be433223a254ef647f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
