class Scmpuff < Formula
  desc "Numeric file selection shortcuts for common git commands"
  homepage "https://github.com/mroth/scmpuff"
  url "https://github.com/mroth/scmpuff/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dbff8913217f6ec0915671057933eacd692e7810bf64ded25bba63e98240b789"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9756cc7881968451d29429fc198dfbda82d8926640b61a08982ddbf249eeba99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9756cc7881968451d29429fc198dfbda82d8926640b61a08982ddbf249eeba99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9756cc7881968451d29429fc198dfbda82d8926640b61a08982ddbf249eeba99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6eb13b0d08abd6f21f1e7c0c0345afe2c28c7d51c2323c5fb8e21fad2e1c1e6d"
    sha256 cellar: :any,                 x86_64_linux:      "fcd10f3b61cf6b5faf6148396c000886ab70a2adfbb0feef5368df0c475db296"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
