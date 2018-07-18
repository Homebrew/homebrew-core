class Goodreadsh < Formula
    desc "Command line interface for Goodreads."
  homepage "https://github.com/prakashdanish/goodreadsh"
  url "https://github.com/prakashdanish/goodreadsh/archive/1.0.1.tar.gz"
  sha256 "63d1de17449611f1490b1930e63cc8890f9f10c7e317f02c901e6a79236c10e2"
  head "https://github.com/prakashdanish/goodreadsh.git"

  bottle :unneeded

  def install
    bin.install "goodreads"
  end

  test do
    system "#{bin}/goodreads"
  end
end
