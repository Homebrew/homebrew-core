class Rsjpg < Formula
  desc "A tool to combine multiple images into a single image"
  homepage "https://github.com/steelPiber/rsjpg"
  url "https://github.com/steelPiber/rsjpg/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "84a661ccc6a39ece8884dc35bdda60be5ccde76d856487580c7641d562d980db"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/rsjpg"
  end

  test do
    system "#{bin}/rsjpg", "--version"
  end
end
