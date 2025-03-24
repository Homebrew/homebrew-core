class Thundery < Formula
  desc "Weather fetching cli"
  homepage "https://github.com/loefey/thundery/"
  url "https://github.com/loefey/thundery/archive/refs/tags/1.0.0.tar.gz"
  sha256 "e91caa3a40ff477ffcc050b3601a9a1d85954bbff3c16e6186671c6c602bfe46"
  license "GPL-3.0-only"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "false"
  end
end
