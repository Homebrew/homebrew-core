class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.41.0.tar.gz"
  sha256 "420a09f77a6355bb0f272cd45be57d89265357b4e98b88e212aba7720d270fe7"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b1923435f9ec78f3a215aed4d908ef0b3ce454fbb5960937ce4e4068e988548" => :catalina
    sha256 "325933b0a61d3094785f82bbe5187b55bd14cb3bb04b968103f46c6f68e338c2" => :mojave
    sha256 "9d62d03d64742b095c24be48ca9fbb230ddb2cadb78b7bdb6aee10e4e2652be5" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
