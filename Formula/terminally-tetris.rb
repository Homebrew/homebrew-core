class TerminallyTetris < Formula
  desc "Play Tetris in the Terminal"
  homepage "https://github.com/thecardkid/terminally-tetris"
  url "https://github.com/thecardkid/terminally-tetris/archive/v1.0.0.tar.gz"
  sha256 "213f8a7581e69d3284291187eb887a1c0822fe699d53a7768f0fea777bc1427b"

  depends_on "cmake" => :build

  def install
    system "make"
    bin.install "build/ttetris"
    man.mkpath
    man1.install "man/ttetris.1"
  end

  test do
    output = shell_output(bin/"ttetris help")
    assert_match "Terminally-Tetris' key bindings", output

    # invalid argument
    output = shell_output(bin/"ttetris save")
    assert_match "Did not recognize argument. See man page for help.", output
  end
end
