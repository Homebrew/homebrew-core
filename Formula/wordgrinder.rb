class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.7.2.tar.gz"
  sha256 "4e1bc659403f98479fe8619655f901c8c03eb87743374548b4d20a41d31d1dff"
  head "https://github.com/davidgiven/wordgrinder.git"

  depends_on "ninja" => :build
  depends_on "lua"

  def install
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1" => "wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system "#{bin}/wordgrinder", "--convert", "#{doc}/README.wg", "#{testpath}/converted.txt"
    assert_predicate testpath/"converted.txt", :exist?
  end
end
