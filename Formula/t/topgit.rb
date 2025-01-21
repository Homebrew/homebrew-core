class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/refs/tags/topgit-0.19.13.tar.gz"
  sha256 "eaab17c64c95e70acfcc9d4061e7cc4143eb5f6dbe7bc23a5091cb45885a682c"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fe4b9aa22aa1c75a5718b0db398e1351457108d92b5414176e46cadca8a1aa47"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
