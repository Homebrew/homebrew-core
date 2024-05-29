class zhistory < Formula
  desc "Command line analysis tool for zsh history"
  homepage "https://github.com/itsKarad/ZHistory"
  url "https://github.com/itsKarad/ZHistory/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/zhistory", "--version"
  end
end
