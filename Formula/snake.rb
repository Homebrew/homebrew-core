class Snake < Formula
  desc "simple snake game. Written in pure java"
  homepage "http://silo.cs.indiana.edu:32903/snake/snakehome.html"
  url "http://silo.cs.indiana.edu:32903/snake/snake.tar.gz"
  version "1.0.0"
  sha256 "c80ef8ce54fa2a4d37de11bd386f04b77ea75b1e012dd3171cec14d86ed26090"
  depends_on "ant" => :build
  depends_on :java
  def install
    system "ant", "compile", "jar"
    mv "snake.jar", "#{prefix}/"
    bin.install "snake"
  end
  test do
    system "java", "-jar", "#{prefix}/snake.jar", "--version"
  end
end
