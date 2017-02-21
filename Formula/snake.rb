class Snake < Formula
  desc "simple snake game. Written in pure java"
  homepage "http://silo.cs.indiana.edu:32903/snake/snakehome.html"
  url "http://silo.cs.indiana.edu:32903/snake/snake.tar.gz"
  version "1.0.0"
  sha256 "9a078047dd9b553f458703afad98ebdcf27907382d05abf99900662de05178dd"
  depends_on "ant" => :build
  depends_on :java
  def install
    system "ant", "compile", "jar"
    bin.install "snake", "snake.jar"
  end
  test do
    system "java", "Snake", "--version"
  end
end
