class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "9bcbbb6576fbb046fc823dfbd9fc592f69791ca7c3a2031be1b1e0b0fe9147e5"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e7f92d6cfb870664231d582d547fa748d137bc7e8826075f759bc281a17dd20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dbc433166e62fb97df5005f95dc94117b5066637209cbc2f6ec78bd3006fb4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cea024c1b241db6f3065e29791cda5257b51e6e4035c2f7ead89615a8959de4"
    sha256 cellar: :any,                 arm64_linux:       "16eb55aba6cf8a5d8b157089d1d04ffb3444d8b6e0cfae3e6189973df6eea53d"
    sha256 cellar: :any,                 x86_64_linux:      "fa0dc3ec38abef37d62cf541cd40fa55002978c2aaa8cba0c4836a09bbd0ef37"
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
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
