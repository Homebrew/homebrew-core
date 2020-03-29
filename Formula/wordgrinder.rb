class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.7.2.tar.gz"
  sha256 "4e1bc659403f98479fe8619655f901c8c03eb87743374548b4d20a41d31d1dff"
  head "https://github.com/davidgiven/wordgrinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05750b2dadc537994d4701005d565782d2afdecfbe1bf1f118f76290255a3946" => :catalina
    sha256 "572bd029f459c15af9a2d27a471e31594d1d9c2387b6ec66f9a890df1db13e55" => :mojave
    sha256 "19855507ccd289049c30aad466a66de742b9d58a98247b9f9d223e140a81ff69" => :high_sierra
  end

  depends_on "ninja" => :build
  depends_on "lua"

  uses_from_macos "zlib"

  def install
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system "#{bin}/wordgrinder", "--convert", "#{doc}/README.wg", "#{testpath}/converted.txt"
    assert_predicate testpath/"converted.txt", :exist?
  end
end
