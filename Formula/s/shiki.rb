class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-3.22.0.tgz"
  sha256 "386d022f5aee850e9a79f972ce7d987e67f928af3af759218335adde496caed9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47bc2836626d8597a1870583f518f304c06fa1fdae00224a057e0f1ed100d0c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end
