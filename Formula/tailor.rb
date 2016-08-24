class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.10.1/tailor-0.10.1.tar"
  sha256 "3960aca4218a773170fb9ac51c7b17b816b2a967c01d6277d45998ebffc961b4"

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
