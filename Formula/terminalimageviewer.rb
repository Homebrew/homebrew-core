class Terminalimageviewer < Formula
  desc "Small program to display images in a terminal using RGB ANSI codes and unicode block graphics characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/v1.0.0.zip"
  sha256 "ab44f7d7b26152590a929fec6586e33a3b47737426467fc02c5d5149593ba094"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git"
  depends_on "imagemagick"
  depends_on "gcc" => :build unless OS.mac?
  def install
    cd "src/main/cpp" do
      system "make"
      bin.install "tiv"
    end
  end

  def caveats
    <<~EOS
      Terminal Image Viewer has been installed as "tiv"
    EOS
  end
  test do
    # Downloads a public domain test file from wikimedia commons and displays it
    system "#{bin}/tiv", "https://upload.wikimedia.org/wikipedia/commons/2/24/Cornell_box.png"
  end
end
