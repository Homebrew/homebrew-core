class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/1.2.0.tar.gz"
  sha256 "84c2db9e0ee00350e3c998d5666ed587a98bd4f2650a1166c7532cfffbb48815"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tssh", "-ldflags", "-X main.version=#{version}"
  end

  test do
    status_output = shell_output("#{bin}/tssh -v")
    assert_match version, status_output
  end
end
