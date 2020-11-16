class Timer < Formula
  desc "Command-line tool to set a timer"
  homepage "https://github.com/annpocoyo/timer/"
  url "https://github.com/annpocoyo/timer/raw/main/Timer/Timer-1.0.0.tar.gz"
  sha256 "46883030d37a7e3d15499365f4ade98384358ea669bb9b2db748f32589c2fff3"
  license "AGPL-3.0-only"

  bottle :unneeded

  def install
    bin.install "Timer"
  end

  test do
    assert_equal "5\n" + "4\n" + "3\n" + "2\n" + "1\n" + "0", shell_output("Timer 5 -s").strip
  end
end
