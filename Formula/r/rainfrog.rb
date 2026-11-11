class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "9bcbbb6576fbb046fc823dfbd9fc592f69791ca7c3a2031be1b1e0b0fe9147e5"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5becd13a49bf8b0299e52e5cf13b15a2161af5564942065d961c5a8cba06c16e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc591db460ef3851fbd0cbf46afba58e1e00b02b65b125acc6df642d74df9eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe3e2e7cd9a0cfa0924b2fd2f444eeed29ea15d214b97dbe61f4d9721397805d"
    sha256 cellar: :any,                 arm64_linux:       "f3b74f8e32161257c94feea4d01cdaa512b44c5661e732a7685789f6b2ec189c"
    sha256 cellar: :any,                 x86_64_linux:      "eb2f77fba5420a5ab7f6af1a2cf3600983b6fd59d759cc7c6858d258667912db"
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
