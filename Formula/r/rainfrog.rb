class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "dc04ede15bc894d66d64a5b15db925b5f371f59f4651b6add043bbaa5cef2e50"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ee3d22045e6ee913b2b76862c4eb2b2811ba7920f127ae10f765538a75b7b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e27385d78c70ebef43a0aa9230a70117b378a6745cf2203d1e03c5b3e6fda6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4023769ffc4fbdd25b9850f9b63a2c4d88e6aeccde5de2c304fb1622f73224c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e50bf071b56407d56b6e3aa868787493818ad32426f0efe93c44a3fb2581a95"
    sha256 cellar: :any_skip_relocation, ventura:       "ecbad32538d407572729a41e8d7d8cee54ada7668a5f9bbc80bf7b577f0a64d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c2461c810472f754280b021c8b2be1bff3082deac57f53ee5f796fd63b79dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e2b006afe3735a1ce14abd53cb110cc6c9eb25c4f7d48b573f90ca0d396ffad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
