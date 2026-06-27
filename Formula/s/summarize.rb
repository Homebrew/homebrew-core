class Summarize < Formula
  desc "Multi-modal AI tool to extract and summarize content"
  homepage "https://summarize.sh"
  url "https://registry.npmjs.org/@steipete/summarize/-/summarize-0.20.1.tgz"
  sha256 "1f3caad2f2142a742ada6511682dbd6d1c80feeec811d309115d3c19fe086522"
  license "MIT"
  head "https://github.com/steipete/summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d25aed7b2ae460de3dcd12fbedcffed6b23d238da6af53f2fce442813d0147c4"
  end

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "tesseract"
  depends_on "yt-dlp"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/summarize --version")

    output = pipe_output("#{bin}/summarize - 2>&1", "Hello from Homebrew test.")
    assert_match "Hello from Homebrew test.", output
  end
end
