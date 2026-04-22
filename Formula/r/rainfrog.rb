class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "3854293991b0dac036d640a7194be7fd71440c1e8739ffad39bab8dc651c8ade"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8e5b7bc7e1ed2687faf4e47d8736a56f9ee109ef66ef7ef1ff785d02f44e17c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8deb9745d8cefc698cc5328432cf291702eab75c9384bf31db3448d867bc60bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d14ae46cea9e8529a86b581e08bc9bd522716ef42d246f03c9631614771edf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f624d48f4c911d48f4f13619070669aaf7a7436f853430cfbe74ee06c9c002a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72811170fa1e263f14500ece775f807cb23448c0b2be3b32a9d8d1332640c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93372b8eddd5f8bddd2f59fed8d61867e6fd678fa2ca44dd9c52d9e1e6967a9"
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
