class Squiid < Formula
  desc "Modular calculator written in Rust"
  homepage "https://imaginaryinfinity.net/"
  url "https://gitlab.com/ImaginaryInfinity/squiid-calculator/squiid/-/archive/1.0.6/squiid-1.0.6.tar.gz"
  sha256 "785dd38de948c9e1fa8ae33a42d092bd21ab57e1399106c37d75962c1bf2ea92"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/squiid", "--version"
  end
end