class Tailor < Formula
  desc "Cross-platform static analyzer and linter for Swift"
  homepage "https://sleekbyte.github.io/tailor/"
  url "https://github.com/sleekbyte/tailor/releases/download/v0.12.0/tailor-0.12.0.tar"
  sha256 "ec3810b27e9a35ecdf3a21987f17cad86918240d773172264e9abbb1a7efc415"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44e1ad8a024ce513684ef98d5cf0087a0c89b7aebbbc3cf2d5905ab71771db54"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"tailor").write_env_script libexec/"bin/tailor", JAVA_HOME: Formula["openjdk"].opt_prefix
    man1.install libexec/"tailor.1"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/tailor", testpath/"Test.swift"
  end
end
