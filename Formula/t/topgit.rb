class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/refs/tags/topgit-0.19.14.tar.gz"
  sha256 "0556485ca8ddf0cf863de4da36b11351545aca74fbf71581ffe9f5a5ce0718cb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00f58e04cdec33f5f8b5a141443aeba8fd6ceb94bc43b834954dbd40eda37e73"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
