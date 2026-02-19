class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "764b8d960fb985229a33224ea871455ac139fae1370c7deca1deec40b2ba42d9"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3440d8be2f9222b45fe1b16583044031f10719e62e20db5cdf8e9d949c0788b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7896f30e643dc427ae25c025fff7e2d4a7d78c7039e48e7b19489912d74186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947a11ae686d3db07f3dec791567111b6a77d4f8b76c21b6bd6027938b195fa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "90a8806dd2515d427c8ca03e48aebe1a4b5b01390081d6f7c6acb7d06e9cdf58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f2b040f3e32c9566ceedf013ad911a1489eb3cdec69d99a70332514f523490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed874f0dc2ad7d151a0b69139799a1a970ecba8435d84471077bfe4900d7d276"
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
