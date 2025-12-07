class TerminalPainter < Formula
  desc "MSPaint for the terminal using the Kitty Graphics Protocol"
  homepage "https://github.com/anand-ts/terminal-painter"
  url "https://github.com/anand-ts/terminal-painter/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9c64bb80384cbe126740ae2c951e03ca2b21f4d448510bf99d6853276ae11144"
  license "MIT"

  depends_on "python@3.12"

  def install
    bin.install "kitty_painter.py" => "terminal-painter"
  end

  def caveats
    <<~EOS
      Requires a terminal that supports the Kitty Graphics Protocol (Kitty, recent WezTerm).
      Run: terminal-painter
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terminal-painter --version")
  end
end
