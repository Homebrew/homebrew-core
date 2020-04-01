class Terminalimageviewer < Formula
  desc "Small program to display images in a terminal using RGB ANSI codes and unicode block graphics characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/v1.0.0.zip"
  sha256 "ab44f7d7b26152590a929fec6586e33a3b47737426467fc02c5d5149593ba094"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git"
  depends_on "imagemagick"
  depends_on "gcc"
  def install
    cd "src/main/cpp" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    # Downloads a public domain test file from wikimedia commons and displays it. For some reason, when you redirect the output it is blank.
    assert_equal "", shell_output("#{bin}/tiv -0 https://upload.wikimedia.org/wikipedia/commons/2/24/Cornell_box.png").strip
  end
end
