class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.13.tar.gz"
  sha256 "dc6a5bd1d0f5a5488cccfb9a9e5ce210c6eb5198661a1ba2cc11b292cf00d406"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82577e013a5e6cb084e9c60404a2e33c2347dc3ddbfe7376a1ac900205d32738"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5970953aa63964470608d5aacad32f6d8e68fc61100b57e5491f45557d5ee07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80a66c9519a5043afc0d8da191702d77740df7d6c3aca3e5e22da46169be857b"
    sha256 cellar: :any,                 arm64_linux:       "7de727619fe5feeae09a8f4821e12b2ab426a7e74f5d61df30d982ff0a1942ed"
    sha256 cellar: :any,                 x86_64_linux:      "c61116993c812bb2d810574e21c36c3c644feb871d8902c90df7fed9cdf05170"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
