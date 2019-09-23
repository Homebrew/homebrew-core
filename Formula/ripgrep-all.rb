class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/0.9.3.tar.gz"
  sha256 "06259e7c1734a9246c2d113bf5e914f4d418e53c201efc697bfc041a713fbef3"
  head "https://github.com/phiresky/ripgrep-all.git"

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
