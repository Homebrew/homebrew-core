class Val < Formula
  desc "Arbitrary precision calculator language"
  homepage "https://github.com/terror/val"
  url "https://github.com/terror/val/archive/refs/tags/0.4.1.tar.gz"
  sha256 "35bf83f2b9095a12959a1b18aee2712a73bcd0079ba9592cd144b18d4ec38262"
  license "CC0-1.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", shell_output("#{bin}/val --expression 'sqrt(16)'").chomp
  end
end
