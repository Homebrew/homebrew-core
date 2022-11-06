class Resfetch < Formula
  desc "Fast and minimal alternative to neofetch"
  homepage "https://github.com/furtidev/resfetch"
  url "https://github.com/furtidev/resfetch/archive/refs/tags/1.0.2.tar.gz"
  sha256 "a04fa166a471dae6bf11be845d5e73df6210a5dc0ff5215db2d1067270d81902"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install"
  end
end
