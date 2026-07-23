class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "39c9c5dbc2eb9153048e7801d756bdf1d38fc2a0d32bff8e52eb05ef342fac10"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "629432a8e55484285e55415c0d3433c645484df302425c0b798c4372e05f51a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983894930d210a059f4864963c960d745677d0395582b659e0c3f50ffe270115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c709eb5f863b5f3da24ff343296d65f3b5c4b543c9912213148c661ed4f48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "afa22b6a00502092fb623a0fb9def23dbb38d59669da7fe9db7da9960ab0aa66"
    sha256 cellar: :any,                 arm64_linux:   "46f8824577d9fcb76e2a7a311f4db145546226dc92081a8a2e0c21468985ddf5"
    sha256 cellar: :any,                 x86_64_linux:  "cac7d7538156c49d787fc177e8d035cf1cbfbc5756482b419270ae9c723781c6"
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
