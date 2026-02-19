class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "2fcb980925c2599be777bb6d48c934ed3344d9a120f28f48d71c97ed03fd8d61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d4d3bd9b0cbf6800aaada905d4ec6d04940bec0e8d7201d5e40166b2b3acbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "612573a71a725c204a16ac4af836d977ca195af4a20a8a5b54f9955d2c573bd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91e71384cf83b531233729ebec9e326e4aca1c3096620fbfbf43522bfcad58db"
    sha256 cellar: :any_skip_relocation, sonoma:        "75f37b1e59afe15bb3e4c8f2e99d742ec84961c50dbf00ffff95de144581cf3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6a7cfc5545011d0afebd69943a8d98f091f6c8b412e611b4ce00b7cea7a6376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e579d713fee60d8a1ed6f7cd67e6cf399a83e4dd62f4515cb6c76a6ebf37b276"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
