class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.8.1/tailor-0.8.1.tar"
  sha256 "6fc393deba25904b583c78b6e81181bfae93e6b33f7cd5f644decce992572d7d"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tailor"
    man1.install libexec/"tailor.1"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/tailor", testpath/"Test.swift"
  end
end
