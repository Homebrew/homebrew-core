class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://tailor.sh"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.12.0/tailor-0.12.0.tar"
  sha256 "ec3810b27e9a35ecdf3a21987f17cad86918240d773172264e9abbb1a7efc415"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"tailor").write_env_script libexec/"bin/tailor", :JAVA_HOME => Formula["openjdk"].opt_prefix
    man1.install libexec/"tailor.1"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/tailor", testpath/"Test.swift"
  end
end
