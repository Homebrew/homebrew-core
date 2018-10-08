class Yeast < Formula
  desc "Yet Another Shell Trick"
  homepage "https://github.com/yvan-sraka/YeAST"
  url "https://github.com/yvan-sraka/YeAST/archive/v0.11.0.tar.gz"
  sha256 "63704eb96ff430845ca2fedd9c1c2d079dc7b3f5d23f0a3cba0e359ffbc44a60"
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    bin.install "kombucha"
  end

  test do
    system "false"
  end
end
